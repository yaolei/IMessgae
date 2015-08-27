/**
 * Created by svs_mini on 13-12-11.
 */

var PORT = 8080;
var IPAddress = '0.0.0.0';
var isHTTPS = false;

if (isHTTPS) {
    var https = require('https');
    var fs = require('fs');
    var url = require("url");

    var options = {
    key: fs.readFileSync('cert/server-key.pem'),
    cert: fs.readFileSync('cert/server-cert.pem')
    };

    function start(route) {
        function onRequest(request, response) {
            var pathname = url.parse(request.url).pathname;
            route(pathname, response, request);
        }
        https.createServer(options, onRequest).listen(PORT, IPAddress);
        console.log("Server has started.");
    }
    exports.start = start;
} else {
    var http = require("http");
    var url = require("url");

    function start(route, handle) {
        function onRequest(request, response) {
            var pathname = url.parse(request.url).pathname;
//            console.log("Request for " + pathname + " received.");
            route(pathname, response, request);
        }

        http.createServer(onRequest).listen(PORT, IPAddress);
        console.log("Server has started.");
    }
    exports.start = start;
}



