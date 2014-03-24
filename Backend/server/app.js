var settings = require('./settings_local');

var db = require('./db');
var express = require('express');
var socket_io = require('socket.io');

var app = express();
// Error logging / handling
app.use(function(err, req, res, next) {
    console.error(err.stack);
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

// Socket IO chat connections
io.sockets.on("connection", function(client) {
    var channels = []
    console.log("connected",client);
    db.subClient.on("message", function (channel, message) {
        console.log("channel: %s", channel);
        if (channels.indexOf(channel) > -1) {
            client.send(message);
        }
    });
client.on("message", function(msg) {
    console.log(msg);
    // Upon connection, subscribe user to relevant channel
    if (msg.type == "setChannel") {
        channels = msg.channel;
        db.subClient.subscribe(channels);
    }
    // Subsequent messages sent
    else if (msg.type == "chat") {
        db.pubClient.publish(msg.channel, msg.message);
    }
// Unsubscribe
    else if (msg.type == 'unsubscribe') {
        var index = channels.indexOf(msg.message);
        // Remove channel from user's subscription set
        db.client.srem(msg.username + ':sub', msg.message);
        if (index > -1) {
            channels.splice(index, 1);
        }
    }
// Subscribe
    else if (msg.type == 'subscribe') {
        var index = channels.indexOf(msg.message);
        // Add channel to user's subscription set
        db.client.sadd(msg.username + ':sub', msg.message);
        if (index > -1) {
            channels.push(msg.message);
        }
    }
});

client.on("disconnect", function() {
    db.pubClient.publish(channels, "User is disconnected: " + client.id);
});
});
