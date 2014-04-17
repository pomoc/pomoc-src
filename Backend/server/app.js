var settings = require('./settings_local');

var db = require('./db');
var express = require('express');
var socket_io = require('socket.io');
var crypto = require('crypto');

// TODO: constants list
// For now:
var TIMESTAMP_BUFFER = 1000;

var app = express();
app.use(express.static(__dirname + '/site'));
app.use(express.bodyParser());
// Error logging / handling
app.use(function(err, req, res, next) {
    res.send(500, 'Something broke!');
});

// Startup servers
var server = app.listen(process.env.PORT || settings.PORT || 3217, function() {
    if (settings.DEBUG) {
        console.log('listening on port %d', server.address().port);
    }
});

var io = socket_io.listen(server, {
    'debug': settings.debug,
    'destroy upgrade' : false
});

// Load all HTTP routes
['routes/index', 'routes/api'].forEach(function(route) {
    require('./' + route)(app, db, crypto);
});

console.log('server running');

// Socke IO connection
io.sockets.on('connection', function(client) {

    var userId;
    var appId;

    // sends a system chat message to the conversation of choice
    function sendSystemMessage(conversationId, message) {
        data = {};
        data.userId = "SYSTEM";
        data.message = message;
        data.conversationId = conversationId;
        data.timestamp = (new Date()).getTime();

        io.sockets.in(conversationId).emit('chatMessage', data);
        db.client.zadd(conversationId, data.timestamp, JSON.stringify(data));
    }

    // ping - announce online presence to app or conversation
    function ping(userId, channel, key, conversationId) {
        var multi = db.client.multi();
        multi.sadd(key, userId);
        multi.smembers(key);
        multi.exec(function(err, replies) {
            var message = {users:replies[1]};
            if (conversationId) {
                message.conversationId = conversationId;
                message.type = 'conversation';
            }
            else {
                message.type = 'app';
            }

            io.sockets.in(channel).emit('onlineStatus', message);
        });
    }


    // INTERNAL MESSAGES
    client.on('internalMessage', function(data, callback) {

        // New Chat
        if (data.type == 'newConversation') {
            var conversationId = data.userId + ':' + data.appId + ':chat';

            // subscribes client to new chat
            client.join(conversationId);

            // adds conversationId to app's list of conversation
            db.client.sadd(data.appId + ':conversations', conversationId);

            // adds conversationId to user's list of conversations
            db.client.sadd(data.userId + ':sub', conversationId);

            // adds userId to list of participants in conversation
            db.client.sadd(conversationId + ':party', data.userId);

            // adds userId to list of online participants in conversation
            db.client.sadd(conversationId + ':online', data.userId);

            console.log(data.userId + ' subscribed to: ' + conversationId);

            // sends back chat id of new chat
            if (callback) {
                callback({success: true, conversationId: conversationId});
            }

            // broadcast notification of new channel to app channel
            var key = data.appId + ':notification';
            client.broadcast.to(data.appId + ':notification').emit('newConversation', {conversationId: conversationId});
            console.log(data.appId + ' notified about: ' + conversationId);
        }

        // Observe conversation lists
        else if (data.type == 'observeConversationList') {
            var key = data.appId + ':notification';
            client.join(key);
            console.log(data.userId + ' observing ' + key);
        }

        // Observe existing conversation
        else if (data.type == 'joinConversation') {
            client.join(data.conversationId);
            console.log('observing ' + data.conversationId);

            // add conversationId to user's list of conversations
            db.client.sadd(data.userId + ':sub', data.conversationId);

            // add userId to list of participants in conversation
            db.client.sadd(data.conversationId + ':party', data.userId);

            // add userId to list of online participants in conversation
            db.client.sadd(data.conversationId + ':online', data.userId);

            // sends back all old messages from chat in response message
            if (callback) {
                var timestamp = (new Date()).getTime();
                db.client.zrange([data.conversationId, 0, timestamp], function(err, reply) {
                    // Convert message string into JSON object
                    reply = reply.map(function(message) {
                        return JSON.parse(message);
                    });
                    callback({success: true, messages: reply});
                    console.log('old messages sent for ' + data.conversationId);
                });
            }
        }

        // pingApp announces online presence to app users
        else if (data.type == 'pingApp') {
            // Sets userId
            console.log('PINGAPP');
            userId = data.userId;
            appId = data.appId;
            ping(data.userId, data.appId + ':notification', data.appId + ':online');
        }
        
        // pingConversation announces online presence to conversation users
        else if (data.type == 'pingConversation') {
            ping(data.userId, data.conversationId, data.conversationId + ':online', data.conversationId);
        }


        // Gets all conversation user is in
        else if (data.type == 'getConversationList') {
            console.log('getConversations ' + data.userId);

            db.client.smembers(data.userId + ":sub", function(err, reply) {
                callback({success: true, conversationIds: reply});
                console.log('conversationIds sent for user:' + data.userId);
            });
        }

        // Gets all conversations for an app
        else if (data.type == 'getAppConversationList') {
            console.log('getAppConversationList ' + data.appId);

            db.client.smembers(data.appId + ":conversations", function(err, reply) {
                callback({success: true, conversationIds: reply});
                console.log('conversationIds sent for app:' + data.appId);
            });
        }

        // Get conversation log
        else if (data.type == 'getConversationLog') {
            if (callback) {
                var timestamp = (new Date()).getTime() + TIMESTAMP_BUFFER;
                db.client.zrange([data.conversationId, 0, timestamp], function(err, reply) {
                    reply = reply.map(function(message) {
                        return JSON.parse(message);
                    });
                    callback({success: true, messages: reply});
                    console.log('old messages sent for ' + data.conversationId);
                });
            }
        }

        // Get list of agents for a given app
        // Doesn't include users
        else if (data.type == 'getAppUsers') {
            if (callback) {
                db.client.smembers(data.appId + ':users', function(err, reply) {
                    callback({success: true, users: reply});
                });
            }
        }


    });


    // APPLICATION MESSAGES
    client.on('applicationMessage', function(data, callback) {
        
        // Handle conversation.
        // Broadcast new handlers list
        if (data.code == 'handle') {
            var multi = db.client.multi();
            // Add agent to the list of agents handling the conversation
            multi.sadd(data.conversationId + ':handlers', data.userId);
            multi.smembers(data.conversationId + ':handlers');
            multi.hgetall(data.userId + ':account');
            multi.exec(function(err, replies) {
                io.sockets.in(data.conversationId).emit('handlerStatus',
                    {type: 'handlers', users: replies[1]});
                sendSystemMessage(data.conversationId, 
                    replies[2].name + ' has started handling the issue');
            });
        }

        // Unhandle conversation
        // Broadcast new handlers list
        else if (data.code == 'unhandle') {
            db.client.srem(data.conversationId + ':handlers', data.userId);
            var multi = db.client.multi();
            // Remove agent from list of agents handling the conversation
            multi.srem(data.conversationId + ':handlers', data.userId);
            multi.smembers(data.conversationId + ':handlers');
            multi.hgetall(data.userId + ':account');
            multi.exec(function(err, replies) {
                io.sockets.in(data.conversationId).emit('handlerStatus',
                    {type: 'handlers', users: replies[1]});
                sendSystemMessage(data.conversationId,
                    replies[2].name + ' has stopped handling the issue');
            });
        }

        // Refer handler
        // Broadcast new handlers list
        else if (data.code == 'referHandler') {
            db.client.sadd(data.coversationId + ':handlers', data.refereeUserId);
            var multi = db.client.multi();
            // Add referred agent to list of agents handling the conersation
            multi.sadd(data.conversationId + ':handlers', data.userId);
            multi.smembers(data.conversationId + ':handlers', data.userId);
            multi.hgetall(data.userId + ':account');
            multi.hgetall(data.refereeUserId + ':account');
            multi.exec(function(err, replies) {
                io.sockets.in(data.conversationId).emit('handlerStatus',
                    {
                        type: 'referral', 
                    refereeUserId: data.referralUserId, 
                    referrerUserId: data.userId, 
                    conversationId: data.conversationId, 
                    users:replies[1]
                    });
                sendSystemMessage(data.conversationId,
                    replies[2].name + ' has referred issue to ' + replies[3].name);
            });
        }

        else if (data.code == 'getHandlers') {
            db.client.smembers(data.conversationId + ':handlers', function(err, reply) {
                if (callback) {
                    if (!err) {
                        callback({success: true, handlers: reply});
                    }
                    else {
                        callback({success: false, error: err});
                    }
                }
            });
        }

    });


    // REGULAR CHAT MESSAGES
    client.on('chatMessage', function(data) {
        data.timestamp = (new Date()).getTime();
        io.sockets.in(data.conversationId).emit('chatMessage', data);

        db.client.zadd(data.conversationId, data.timestamp, JSON.stringify(data));
        console.log(data.userId + ' sent: ' + data.message + ' channel: ' + data.conversationId);
    });


    // DISCONNECT
    client.on('disconnect', function() {
        // Get list of conversations users is in
        db.client.smembers(userId + ':sub', function(err, conversations) {
            var multiRemove = db.client.multi();
            // Remove user from the online user list for each convo user is in
            for (var i = 0; i < conversations.length; i++) {
                multiRemove.srem(conversations[i] + ':online', userId);
            }
            // Remove user from the online 
            multiRemove.srem(appId + ':online', userId);

            multiRemove.exec(function(err, replies) {    
                // announce new list of online users for app
                db.client.smembers(appId + ':online', function(err, reply) {
                    io.sockets.in(appId + ':notification').emit('onlineStatus', {type:'app', users:reply});
                });

                // announce new list of online users for each converation that
                // user was in
                for (var j = 0; j < conversations.length; j++) {
                    db.client.smembers(conversations[j] + ':online', function(err, reply) { 
                        io.sockets.in(conversations[j]).emit('onlineStatus', {type:'conversation', users:reply, conversationId:conversations[j]});
                        console.log('Disconnected from: ' + conversations[j]);
                    });
                }
            });
        });
    });

});
