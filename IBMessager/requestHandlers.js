/**
 * Created by svs_mini on 13-12-11.
 */

var querystring = require("querystring"),
    fs = require("fs"),
    formidable = require("formidable");

//DB init
var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/ibmessager');
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function (callback) {
    console.log('db open');
//
//    var userSchema = mongoose.Schema({
//        name: String,
//        password: String
//    });
//
//    var userModel = mongoose.model('users', userSchema);
//
//    var testUser = new userModel({name : "test2", password : "pwd2"});
//
//    testUser.save(function (err, user) {
//        if (err) return console.error(err);
//    });
//
//    userModel.find({name:'test'}, function (err, users) {
//        if (err) return console.error(err);
//        console.log(users);
//    });
});


//import some models
var userModel = require('./Models/UserModel.js');
var messageModel = require('./Models/MessageModel.js');


//inner function
function handlePostRequestAsync(request, callback)
{

    var postData = "";
    request.setEncoding("utf8");
    request.addListener("data", function(postDataChunk) {
        postData += postDataChunk;
    });

    request.addListener("end", function() {
        var exec = require("child_process").exec;
        exec("", function (error, stdout, stderr) {
            callback(postData, error, stdout, stderr);
        });
    });
}

function handlePostRequestSync(request, callback)
{
    var postData = "";
    request.setEncoding("utf8");
    request.addListener("data", function(postDataChunk) {
        postData += postDataChunk;
    });

    request.addListener("end", function() {
        callback(postData);
    });
}

function sendResponceWithBody(response, body)
{
    response.writeHead(200, {"Content-Type": "application/json"});
    response.write(body);
    response.end();
}

function getErrorWithMessage(msg)
{
    return {error:msg};
}

//export interface
function start(response)
{
    var body = 'Welcome';
    response.writeHead(200, {"Content-Type": "text/html"});
    response.write(body);
    response.end();
}

//用户登陆
function login(response, request)
{
    handlePostRequestAsync(request, function(postData, error, stdout, stderr) {
        var json = JSON.parse(postData);

        var name = json.name;
        var password = json.password;

        userModel.checkLogin(name, password, function(found) {
            if (found) {
                var jsonStr = JSON.stringify(found);
                sendResponceWithBody(response, jsonStr);
            }
        });
    });
}

function sendMsg(response, request)
{
    handlePostRequestAsync(request, function(postData, error, stdout, stderr) {
        var json = JSON.parse(postData);
        var msg = json.msg;

        if (msg) {
            messageModel.send(msg.from, msg.to, msg.chattype, msg.content, msg.url, function(error) {
                var jsonStr;
                if (error) {
                    jsonStr = JSON.stringify({error : 1});
                } else {
                    jsonStr = JSON.stringify({error : 0});
                }

                sendResponceWithBody(response, jsonStr);
            });
        }


    });
}

function getLatestMessages(response, request)
{
    handlePostRequestAsync(request, function(postData, error, stdout, stderr) {
        var json = JSON.parse(postData);

        if (!json.late) {
            json.late = (new Date()).toString();
        }
        if (!json.early) {
            json.early = (new Date('2015-01-01 01:01:01')).toString();
        }

        messageModel.getLatestMessages(json.from , json.to, json.early, json.late, function(results) {
            var jsonStr;
            if (results) {
                jsonStr = results;
            } else {
                jsonStr = getErrorWithMessage('no record');
            }
            jsonStr = JSON.stringify(jsonStr);
            sendResponceWithBody(response, jsonStr);
        });
    });
}

function getUserBriefInfo(response, request)
{
    handlePostRequestAsync(request, function(postData, error, stdout, stderr) {
        var json = JSON.parse(postData);
        var jsonStr;

        userModel.getUserBriefInfo(json.userIDs, function(results) {
            if (results) {
                jsonStr = {data:results};
            } else {
                jsonStr = getErrorWithMessage('get brief info failed');
            }
            jsonStr = JSON.stringify(jsonStr);
            sendResponceWithBody(response, jsonStr);
        });
    });
}

function addFriend(response, request) {
    handlePostRequestAsync(request, function(postData, error, stdout, stderr) {
        var json = JSON.parse(postData);
        var jsonStr;
        if (json.targetID == json.myID) {
            jsonStr = getErrorWithMessage("cannot add self as a friend");
            jsonStr = JSON.stringify(jsonStr);
            sendResponceWithBody(response, jsonStr);
        } else {
            userModel.addFriend(json.targetID, json.myID, function(results) {
                if (results) {
                    jsonStr = results;
                } else {
                    jsonStr = getErrorWithMessage('add friend failed');
                }
                jsonStr = JSON.stringify(jsonStr);
                sendResponceWithBody(response, jsonStr);
            });
        }
    });
}

function getMyFriendsList(response, request) {
    handlePostRequestAsync(request, function(postData, error, stdout, stderr) {
        var json = JSON.parse(postData);

        userModel.getFriendList(json.targetID, function(results) {
            var jsonStr;
            if (results) {
                jsonStr = {data:results};
            } else {
                jsonStr = getErrorWithMessage('get friend list failed');
            }
            jsonStr = JSON.stringify(jsonStr);
            sendResponceWithBody(response, jsonStr);
        });
    });
}

function searchFriend(response, request) {
    handlePostRequestAsync(request, function(postData, error, stdout, stderr) {
        var json = JSON.parse(postData);

        userModel.searchFriend(json.targetID, function(results) {
            var jsonStr;
            if (results) {
                jsonStr = {data:results};
            } else {
                jsonStr = getErrorWithMessage('search friend failed');
            }
            jsonStr = JSON.stringify(jsonStr);
            sendResponceWithBody(response, jsonStr);
        });
    });
}

function checkNewMessage(response, request) {
    handlePostRequestAsync(request, function(postData, error, stdout, stderr) {
        var json = JSON.parse(postData);

        messageModel.checkNewMessage(json.myID, json.timestamp, function(results) {
            var jsonStr;
            if (results) {
                jsonStr = results;
            } else {
                jsonStr = getErrorWithMessage('check new msg failed');
            }
            jsonStr = JSON.stringify(jsonStr);
            sendResponceWithBody(response, jsonStr);
        });
    });
};

exports.start = start;
exports.login = login;
exports.sendMsg = sendMsg;
exports.getLatestMessages = getLatestMessages;
exports.checkNewMessage = checkNewMessage;
exports.addFriend = addFriend;
exports.getMyFriendsList = getMyFriendsList;
exports.searchFriend = searchFriend;
exports.getUserBriefInfo = getUserBriefInfo;