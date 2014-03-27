module.exports = function(app) {
    app.get('/', function(req, res) {   
        res.send("HELLO");
       // res.sendfile("index.html");
    });
}
