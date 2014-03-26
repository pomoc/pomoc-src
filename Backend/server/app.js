var settings = require('./settings_local');

var db = require('./db');
var express = require('express');
var socket_io = require('socket.io');

var app = express();
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
    require('./' + route)(app, db);
});

console.log('server running');

// Socke IO connection
io.sockets.on('connection', function(client) {

    // Subscribe
    client.on('subscribe', function(data) {
        client.join(data.channel);
        db.client.sadd(data.username + ":sub", data.channel);
        console.log(data.username + " subscribed: " + data.channel);
    });

    // Unsubscribe
    client.on('unsubscribe', function(data) {
        client.leave(data.channel);
        db.client.srem(data.username + ":sub", data.channel); 
        console.log(data.username + " unsubscribed: " + data.channel);
    });

    client.on('internalMessage', function(data, callback) {
        // New Chat
        if (data.type == "newConversation") {
            var conversationId = data.userId + ":" + data.appId + ":chat";

            // subscribes client to new chat
            client.join(conversationId);

            db.client.sadd(data.userId + ":sub", conversationId);
            console.log(data.userId + " subscribed to: " + conversationId);

            // sends back chat id of new chat
            if (callback) {
                callback({success: true, conversationId: conversationId});
            }

            // broadcast notification of new channel
            client.broadcast.to(data.appId + ":notification", conversationId);
            console.log(data.appId + " notified about: " + conversationId);
        }

        // Observe conversation lists
        if (data.type == "observeConversationList") {
            var key = data.appId + ":notification";
            client.join(key);
        }
    });

    client.on('chatMessage', function(data) {
        data.timestamp = (new Date()).getTime();
        io.sockets.in(data.conversationId).emit('chatMessage', data);

        db.client.zadd(data.conversationId, data.timestamp, JSON.stringify(data));
        console.log(data.userId + " sent: " + data.message + " channel: " + data.conversationId);
    });

    // Disconnect
    client.on('disconnect', function() {});
});
