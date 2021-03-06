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
io.
// Load all HTTP routes
['routes/index', 'routes/api'].forEach(function(route) {
    require('./' + route)(app, db);
});

// Socket IO chat connections
io.sockets.on("connection", function(client) {
    var channels = []
    db.subClient.on("message", function (channel, message) {
        console.log("channel: %s", channel);
        if (channels.indexOf(channel) > -1) {
            client.send(message);
        }
    });

    // User initiates chat
    // channel name = user:appid:chat
    // msg.channel contains appId
    client.on("init", function(msg, fn) {
        var channelId = msg.username + ":" +  msg.channel + ":chat";
        channels.push(channelId);
        db.subClient.subscribe(channelId);
        // Send chatId back to user
        fn(JSON.stringify({
            type: "init",
            channel: channelId,
            message: "",
            username: ""
        }));

        // Notify all support staff about the new channel through the app's 
        // notification channel
        var notification_msg = {
            type: 'notification',
            channel: channelId,
            message: '',
            username: ''
        }
        console.log("publishing: " + msg.channel + ":notification");
        db.pubClient.publish(msg.channel + ":notification",
                JSON.stringify(notification_msg));
    });
    
    client.on("message", function(msg) {
        if (msg.type == "chat") {
            // publish message
            db.pubClient.publish(msg.channel, JSON.stringify(msg));
            // store message
            db.client.zadd([msg.channel, msg.timestamp, JSON.stringify(msg)],
                function(err, reply){});
        }

        // Unsubscribe
        else if (msg.type == 'unsubscribe') {
            var index = channels.indexOf(msg.channel);
            console.log("unsubscribed: " + msg.username + "," + msg.channel);
            // Remove channel from user's subscription set
            db.client.srem(msg.channel);
            if (index > -1) {
                channels.splice(index, 1);
            }
        }

        // Subscribe
        else if (msg.type == 'subscribe') {
            console.log("Subscribed: " + "user="+ msg.username + " channel=" + msg.channel);
            var index = channels.indexOf(msg.channel);
            // Add channel to user's subscription set
            db.client.sadd(msg.channel, msg.username);
            if (index < 0) {
                console.log("channel " + msg.channel + " pushed");
                channels.push(msg.channel);
            }
            db.subClient.subscribe(msg.channel);
        }
    });

    client.on("disconnect", function() {
        db.pubClient.publish(channels, "User is disconnected: " + client.id);
    });
});
