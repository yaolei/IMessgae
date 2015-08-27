/**
 * Created by svs_mini on 13-12-11.
 */

var server = require("./server");
var router = require("./router");


server.start(router.route);