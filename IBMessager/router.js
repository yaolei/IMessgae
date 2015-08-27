/**
 * Created by svs_mini on 13-12-11.
 */

var requestHandlers = require("./requestHandlers");

var handle = {};
handle["/"] = requestHandlers.start;
handle["/login"] = requestHandlers.login;
handle["/sendMsg"] = requestHandlers.sendMsg;
handle["/getLatestMessages"] = requestHandlers.getLatestMessages;
handle["/addFriend"] = requestHandlers.addFriend;
handle["/getMyFriendsList"] = requestHandlers.getMyFriendsList;
handle["/searchFriend"] = requestHandlers.searchFriend;
handle["/checkNewMessage"] = requestHandlers.checkNewMessage;
handle["/getUserBriefInfo"] = requestHandlers.getUserBriefInfo;

function route(pathname, response, request) {
    if (typeof handle[pathname] === 'function') {
        handle[pathname](response, request);
    } else {
        console.log("No request handler found for " + pathname);
        response.writeHead(404, {"Content-Type": "text/html"});
        response.write("404 Not found");
        response.end();
    }
}

exports.route = route;