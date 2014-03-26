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

    // Relaying chat messages
    client.on('message', function(data) {
        // broadcasts to all clients in room except this one
       client.broadcast.to(data.channel).emit('message', data);
        // send message back to client
       client.emit('message', data);
       db.client.zadd([data.channel, data.timestamp, JSON.stringify(data)], function(err,reply){});
       console.log(data.username + " sent: " + data.message + " channel: " + data.channel);
    });

    // New Chat
    client.on('init', function(data, callback) {
        var channelId = data.username + ":" + data.channel + ":" + chat;
        // subscribes client to new chat
        client.join(channelId);
        db.client.sadd(data.username + ":sub", channelId);
        console.log(data.username + " subscribed to: " + channelId);
        // sends back chat id of new chat
        callback(JSON.stringify({
            type: "init",
            channel: channelId,
            message: "",
            username: ""
        }));
        // broadcast notification of new channel
        client.broadcast.to(data.channel + ":notification", channelId);
        console.log(data.channel + " notified about: " + channelId);
    });
    
    // Disconnect
    client.on('disconnect', function() {});
});
