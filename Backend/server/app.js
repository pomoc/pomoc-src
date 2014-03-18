var express = require('express');
var redis = require("redis")
var fs = require('fs');
var app = express();

var port = 8000;
var server = app.listen(8000, function() {
    console.log('listening on port %d', server.address().port);
});
var io = require("socket.io").listen(server);

var store = redis.createClient(); // for storing chat messages
var pub = redis.createClient(); // for publishing to channels
var sub = redis.createClient(); // for subscription to channels

// FOR TESTING:
// loads html page
app.get('/', function(req, res) {
    res.sendfile("index.html");
});

// Socket IO chat connections
io.sockets.on("connection", function(client) {
    var channelId; // Chat Id
    sub.on("message", function (channel, message) {
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
            sub.subscribe(channelId);
        }
        // Subsequent messages sent
        else if (msg.type == "chat") {
            pub.publish(channelId, msg.message);
        }
    });

    client.on("disconnect", function() {
        pub.publish(channelId, "User is disconnected: " + client.id);
    });
});

// Error logging / handling
app.use(function(err, req, res, next){
      console.error(err.stack);
        res.send(500, 'Something broke!');
});

