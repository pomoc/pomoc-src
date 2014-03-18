var settings = require('./settings_local');

var express = require('express');
var redis = require("redis")
var app = express();

var port = process.env.PORT || settings.PORT || 3217;
var server = app.listen(port, function() {
    console.log('listening on port %d', server.address().port);
});
var io = require("socket.io").listen(server);

function getRedisClient() {
    var port = process.env.REDIS_PORT || settings.REDIS_PORT || 6379;
    var host = process.env.REDIS_HOST || settings.REDIS_HOST || 'localhost';

    return redis.createClient(port, host);
}

var store = getRedisClient();    // for storing chat messages
var pub = getRedisClient();     // for publishing to channels
var sub = getRedisClient();     // for subscription to channels

// FOR TESTING:
// loads html page
app.get('/', function(req, res) {
    res.sendfile("index.html");
});

// Error logging / handling
app.use(function(err, req, res, next){
      console.error(err.stack);
        res.send(500, 'Something broke!');
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


