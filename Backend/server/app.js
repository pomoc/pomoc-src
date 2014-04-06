var settings = require('./settings_local');

var db = require('./db');
var express = require('express');
var socket_io = require('socket.io');
var crypto = require('crypto');

var app = express();
app.use(express.static(__dirname + '/site'));
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

    // INTERNAL MESSAGES
    client.on('internalMessage', function(data, callback) {
        // New Chat
        if (data.type == 'newConversation') {
            var conversationId = data.userId + ':' + data.appId + ':chat';

            // subscribes client to new chat
            client.join(conversationId);
            db.client.sadd(data.userId + ':sub', conversationId);
            db.client.sadd(conversationId + ':party', data.userId);
            db.client.sadd(conversationId + ':active', data.userId);

            // client also joins the chat activity channel
            client.join(conversationId + ':activity');

            console.log(data.userId + ' subscribed to: ' + conversationId);

            // sends back chat id of new chat
            if (callback) {
                callback({success: true, conversationId: conversationId});
            }

            // broadcast notification of new channel
            var key = data.appId + ':notification';
            client.broadcast.to(data.appId + ':notification').emit('newConversation', {conversationId: conversationId});
            console.log(data.appId + ' notified about: ' + conversationId);
        }

        // Observe conversation lists
        else if (data.type == 'observeConversationList') {
            var key = data.appId + ':notification';
            console.log(data.userId + ' observing ' + key);
            client.join(key);
        }

        // Observe existing conversation
        else if (data.type == 'joinConversation') {
            console.log('observing ' + data.conversationId);
            client.join(data.conversationId);
            db.client.sadd(data.userId + ':sub', data.conversationId);
            db.client.sadd(data.conversationId + ':party', data.userId);
            db.client.sadd(data.conversationId + ':active', data.userId);

            // client also joins the chat activity channel
            client.join(data.conversationId + ':activity');

            // sends back all old messages from chat
            if (callback) {
                var timestamp = (new Date()).getTime();
                db.client.zrange([data.conversationId, 0, timestamp], function(err, reply) {
                    reply = reply.map(function(message) {
                        return JSON.parse(message);
                    });
                    callback({success: true, messages: reply});
                    console.log('old messages sent for ' + data.conversationId);
                });
            }
        }

        // Initial ping announces online presence
        else if (data.type == 'ping') {
            console.log('ping ' + data.userId);
            userId = data.userId;

            db.client.smembers(data.userId + ":sub", function(err, reply) {
                reply.map(function(conversationId) {
                    db.client.sadd(conversationId, data.userId);

                    // Register client's activity for each conversation
                    client.join(conversationId + ':activity');
                    db.client.smembers(conversationId + ':active', function(err, reply) {
                        // Broadcasts list of active user for each conversation
                        client.broadcast.to(conversationId + ':activity').emit('activity', reply);
                    });
                });
            });
        }


        // Gets all conversation user is in
        else if (data.type == 'getConversationList') {
            console.log('getConversations ' + data.userId);

            // Get list of conversation ids
            db.client.smembers(data.userId + ":sub", function(err, reply) {
                callback({success: true, conversationIds: reply});
                console.log('conversationIds sent for + ', data.userId);
            });
        }


        // Get conversation log
        else if (data.type == 'getConversationLog') {
             if (callback) {
                var timestamp = (new Date()).getTime();
                db.client.zrange([data.conversationId, 0, timestamp], function(err, reply) {
                    reply = reply.map(function(message) {
                        return JSON.parse(message);
                    });
                    callback({success: true, messages: reply});
                    console.log('old messages sent for ' + data.conversationId);
                });
            }
        }

    });


    // REGULAR CHAT MESSGES
    client.on('chatMessage', function(data) {
        data.timestamp = (new Date()).getTime();
        io.sockets.in(data.conversationId).emit('chatMessage', data);

        db.client.zadd(data.conversationId, data.timestamp, JSON.stringify(data));
        console.log(data.userId + ' sent: ' + data.message + ' channel: ' + data.conversationId);
    });

    // Disconnect
    client.on('disconnect', function() {});
});
