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
                    "type", "agent"
                    );
                res.statusCode = 200;
                response = {success: true};
                // Add user to app's list of users/agents
                db.client.sadd(req.body.appToken + ':users', req.body.userId);
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
                "type", "agent"
                );

            // Add super user to list of app users
            db.client.sadd(appToken + ':users', req.body.userId);

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

    
    app.get('/appUsers/:appId', function(req, res) {
        var key = req.param('appId') + ':users';
        db.client.smembers(key, function(err, reply) {
            var fields = ['name', 'userId', 'type'];
            var multi = db.client.multi();
            for (var userId in reply) {
                multi.hmget([reply[userId] + ':account'].concat(fields));
            }
            multi.exec(function(errMulti, replies) {
                var result = [];
                for (var user in replies) {
                    var userObj = {
                        "name": replies[user][0],
                        "userId": replies[user][1],
                        "type": replies[user][2]
                    }
                    result.push(userObj);
                }
                res.send(result);
            });
        });
    });

    
    app.get('/reset', function(req, res) {
        var usernames = ['steve', 'chunmun', 'soedar', 'banghui', 'yangshun'];
        var appToken = "1D129EF1042";
        var appSecret = "F1293AD9E";
        db.client.FLUSHALL();
        usernames.map(function(username) {
            var salt = Date.now();
            var hash =  crypto.createHash('sha1');
            hash.write(username);
            var password = hash.digest('hex');
            db.client.hmset(username + ":account",
                "name", username,
                "userId", username,
                "password", password,
                "salt", salt,
                "appToken", appToken,
                "appSecret", appSecret,
                "type", "agent"
                );
            db.client.sadd(appToken + ":users", username);
        });
        res.send("YOLO RESET!");
    });


    function getPublicUserObject(userId, callback) {
        var key = userId + ':account';
        var fields = ['name', 'userId', 'appToken', 'appSecret', 'type'];
        db.client.hmget([key].concat(fields), function(err, reply) {
            var result = {}
            for (var i = 0; i < fields.length; i++) {
                result[fields[i]] = reply[i];
            }
            callback(result)
        });
    }
}
