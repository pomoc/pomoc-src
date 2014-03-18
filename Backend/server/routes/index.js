module.exports = function(app) {
    app.get('/', function(req, res) {
        res.sendfile("index.html");
    });
}
