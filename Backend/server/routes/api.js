module.exports = function(app, db, crypto) {

    // User registration
    app.post('/userRegistration', function(req, res) {
        // Returns {success:true} or {success:false, error:""}
        var key = req.body.userId + ":account";
        res.statusCode = 400;
        db.client.hgetall(key, function(err, reply) {
            var response = {success: false, error: "user already exists"};
            if (!reply) {
                var salt = Date.now();
                var hash = crypto.createHash('sha1');
                hash.write(req.body.password + salt);
                var password = hash.digest('hex');
                // Store user data
                db.client.hmset(key,
                    "name", req.body.userId,
                    "userId", req.body.userId,
                    "password", password,
                    "salt", salt,
                    "appToken", req.body.appToken,
                    "appSecret", req.body.appSecret,
                    "type", "admin"
                );
                res.statusCode = 200;
                response = {success: true};
            }
            res.send(response);
        });
    });

    // User login
    app.post('/agentLogin', function(req, res) {
        var key = req.body.userId + ":account";
        db.client.hgetall(key, function(err, reply) {
            if (reply) {
                var credentials = reply;
                console.log(credentials);
                var hash = crypto.createHash('sha1');
                hash.write(req.body.password + credentials.salt);
                var password = hash.digest('hex');

                if (password == credentials.password) {
                    var response = {
                        success: true,
                        userId: credentials.userId,
                        name: credentials.name,
                        type: credentials.type,
                        appToken: credentials.appToken,
                        appSecret: credentials.appSecret
                    }
                    res.statusCode = 200;
                    res.send(response);
                }
            }

            // No such user exist or wrong password
            var response = {success: false, error: 'wrong username/password'};
            res.statusCode = 400
            res.send(response);
        });
    });

    // App registration / AKA root user registration
    // Registration generates appToken and appSecret that will be sent in the response
    app.post('/appRegistration', function(req, res) {
        // Guilty till proven innocent
        res.statusCode = 400

        var appHash = crypto.createHash('sha1');
        appHash.write(req.body.userId);
        var appToken = appHash.digest('hex');
        var appKey = appToken + ":app";
        db.client.smembers(appKey, function(err, reply) {
            var response = {success: false, error: "app already registered"};
            if (reply.length == 0) {
                // Generate appToken and appSecret
                // trivial app_token omg bbq
                var userKey = req.body.userId + ':account';
                var salt = Date.now();
                var appSecret = salt + appToken;
                var hash = crypto.createHash('sha1');
                hash.write(req.body.password + salt);
                var password = hash.digest('hex');

                // Store super user data
                // TODO: check if user already exists, currently doesnt bother
                db.client.hmset(userKey,
                    "name", req.body.userId,
                    "userId", req.body.userId,
                    "password", password,
                    "salt", salt,
                    "appToken", appToken,
                    "appSecret", appSecret,
                    "type", "super"
                );

                // Create app user list
                db.client.sadd(appKey, userKey); 

                // Return appToken and appSecret
                res.statusCode = 200;
                response = {success:true, appToken:appToken, appSecret:appSecret};
            }
            res.send(response);
        });
    });

    app.get('/user/:userId', function(req, res) {
        getPublicUserObject(req.param('userId'), function(result) {
            if (result == {}) {
                res.statusCode = 400;
            }
            res.send(result);
        });
    });


    app.post('/user/:userId', function(req, res) {
        var key = req.param('userId') + ':account';
        db.client.hmset(
            key,
            {'userId': req.param('userId'), 'name': req.body.name},
            function(err, reply) {
                getPublicUserObject(req.param('userId'), function(result) {
                    if (result == {}) {
                        res.statusCode = 400;
                    }
                    res.send(result);
                });
        });
    });


    function getPublicUserObject(userId, callback) {
        var key = req.param('userId') + ':account';
        var fields = ['name', 'userId', 'appToken', 'appSecret', 'type'];
        db.client.hmget([key].concat(fields), function(err, reply) {
            var result = {}
            for (var i = 0; i < fields.length; i++) {
                result[fields[i]] = reply[i];
            }
            callback(response)
        });
    }
}
