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
['routes/index'].forEach(function(route) {
    require('./' + route)(app, db);
});

// Socket IO chat connections
io.sockets.on("connection", function(client) {
    console.log("connected",client);
    var channelId; // Chat Id
    db.subClient.on("message", function (channel, message) {
        console.log("channel: %s", channel);
        if (channel == channelId) {
            client.send(message);
        }
    });
    client.on("message", function(msg) {
        console.log(msg);
        // Upon connection, subscribe user to relevant channel
        if (msg.type == "setChannel") {
            channelId = msg.channel;
            db.subClient.subscribe(channelId);
        }
        // Subsequent messages sent
        else if (msg.type == "chat") {
            db.pubClient.publish(channelId, msg.message);
        }
    });

    client.on("disconnect", function() {
        db.pubClient.publish(channelId, "User is disconnected: " + client.id);
    });
});
