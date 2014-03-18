var settings = require('./settings_local');
var redis = require('redis');


module.exports = function () {
    function createClient() {
        var port = process.env.REDIS_PORT || settings.REDIS_PORT || 6379;
        var host = process.env.REDIS_HOST || settings.REDIS_HOST || 'localhost';

        return redis.createClient(port, host);
    }

    return {client: createClient(),
            subClient: createClient(),
            pubClient: createClient()};
}();
