module.exports = function(app, db) {
    // Get chat messages for user
    app.get('/get_chat/:username', function(req, res) {
        var ts = Date.now();
        var username = req.param('username')
        console.log(username + ':sub');
        db.client.smembers(username + ':sub',
            function(err, channels){
                console.log(channels);
                // Redis multi command queue
                var multi = db.client.multi();
                for (var i in channels) {
                    multi.zrange([channels[i], 0, ts], function(err, reply){console.log(reply)});
                }
                // Drain multi queue
                multi.exec(function(err, replies) {
                    console.log(replies);
                    res.send(JSON.stringify(replies));
                });
            });
    });
}
