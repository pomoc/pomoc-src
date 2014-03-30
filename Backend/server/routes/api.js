module.exports = function(app, db, crypto) {

    // User registration
    app.post('/userregistration', function(req, res) {
        // Returns {success:true} or {success:false, error:""}
        // TODO: Find out how we are going to use appId and apiKey.
        var key = req.query.userId + ":account";
        db.client.hgetall(key, function(err, reply){
            var response = {success: false, error: "user already exists"};
            if (!reply) {
                var salt = Date.now();
                var hash = crypto.createHash('sha1');
                hash.write(req.query.password + salt);
                var password = hash.digest('hex');
                // Store user data
                db.client.hmset(key, "name", req.query.userId, "userId", req.query.userId, "password", password, "appId", req.query.appId);

                /*
                // To check if credentials have been stored correctly
                db.client.hgetall(key, function(err, reply) {
                    console.log('here');
                    console.log(reply);
                });
                */

                response = {success: true};
            }
            res.send(response);
        });
    });

    // App registration
    // Registration generates apiKey that will be sent in the response
    // Registration would mean enabling service for that appId
    app.post('/appregistration', function(req, res) {
        var key = req.query.appId + ":apiKey";
        db.clent.get(key, function(err, reply) {
            var response = {success: false, error: "app already registered"};
            if (!reply) {
                // TODO: Register application
            }
            res.send(response);
        });
    });

    // TODO:
    // User login
    // App login
}
