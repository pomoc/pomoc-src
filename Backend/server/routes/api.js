module.exports = function(app, db, crypto) {

    // User registration
    app.post('/userregistration', function(req, res) {
        // Returns {success:true} or {success:false, error:""}
        var key = req.query.userId + ":account";
        db.client.hgetall(key, function(err, reply) {
            var response = {success: false, error: "user already exists"};
            if (!reply) {
                var salt = Date.now();
                var hash = crypto.createHash('sha1');
                hash.write(req.query.password + salt);
                var password = hash.digest('hex');
                // Store user data
                db.client.hmset(key,
                    "name", req.query.userId,
                    "userId", req.query.userId,
                    "password", password,
                    "salt", salt,
                    "appToken", req.query.appToken,
                    "appSecret", req.query.appSecret,
                    "type", "admin"
                );

                response = {success: true};
            }
            res.send(response);
        });
    });

    // User login
    app.post('/login', function(req, res) {
        var key = req.query.userId + ":account";
        db.client.hgetall(key, function(err, reply) {
            if (reply) {
                var credentials = reply;
                console.log(credentials);
                var hash = crypto.createHash('sha1');
                hash.write(req.query.password + credentials.salt);
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
                    res.send(response);
                }
            }

            // No such user exist or wrong password
            var response = {success: false, error: 'wrong username/password'};
            res.send(response);
        });
    });

    // App registration / AKA root user registration
    // Registration generates appToken and appSecret that will be sent in the response
    app.post('/appregistration', function(req, res) {
        var appHash = crypto.createHash('sha1');
        appHash.write(req.query.userId);
        var appToken = appHash.digest('hex');
        var appKey = appToken + ":app";
        db.client.smembers(appKey, function(err, reply) {
            console.log(reply);
            var response = {success: false, error: "app already registered"};
            if (!reply) {
                // Generate appToken and appSecret
                // trivial app_token omg bbq
                var userKey = req.query.userId + ':account';
                var salt = Date.now();
                var appSecret = salt + appToken;
                var hash = crypto.createHash('sha1');
                hash.write(req.query.password + salt);
                var password = hash.digest('hex');

                // Store super user data
                // TODO: check if user already exists, currently doesnt bother
                db.client.hmset(userKey,
                    "name", req.query.userId,
                    "userId", req.query.userId,
                    "password", password,
                    "salt", salt,
                    "appToken", appToken,
                    "appSecret", appSecret,
                    "type", "super"
                );

                // Create app user list
                db.client.sadd(appKey, userKey); 

                // Return appToken and appSecret
                response = {success:true, appToken:appToken, appSecret:appSecret};
            }
            res.send(response);
        });
    });

}
