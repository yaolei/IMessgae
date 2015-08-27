/**
 * Created by wanglongyan on 15/6/10.
 */


var mongoose = require('mongoose');

var msgSchema = mongoose.Schema({
    from:       String,
    to:         String,
    timestamp:  Date,
    chattype:   String,
    content:    String,
    url:        String
});

msgSchema.methods.fun = function (callback) {

};

msgSchema.methods.send = function (callback) {
    this.save(function(error) {
        callback(error);
    });
};


exports.model = mongoose.model('messages', msgSchema);
exports.send = function(fromUser, toUser, chattype, content, url, callback) {

    var sendMsg = new exports.model({
        from:fromUser,
        to:toUser,
        timestamp:new Date().toString(),
        chattype:chattype,
        content:content,
        url:url
    });
    sendMsg.send(function (error) {
        callback(error);
    });
};

exports.getLatestMessages = function (fromId, toId, early, late, callback) {
    var con1 = {$or: [{to : toId, from : fromId}, {to : fromId, from : toId}]};
    var con2 = {timestamp: {$lte: new Date(late), $gt: new Date(early)}};
    var conditions = {$and:[con1, con2]};
    exports.model.find(conditions).sort({'timestamp':-1}).limit(20).exec(function(err,msgs){
        if (msgs.length >= 0) {
            msgs.reverse();
            callback(msgs);
        } else {
            callback(undefined);
        }
    });
};

exports.checkNewMessage = function(myID, timeStamp, callback) {
    var date = new Date();
    var con1 = {$or: [{to : myID}, {from : myID}]};
    var con2 = {timestamp: {$lte: date, $gt: new Date(timeStamp)}};
    var conditions = {$and:[con1, con2]};
    exports.model.find(conditions).exec(function(err,results){
        if (err || !results || results.length == 0) {
            callback(undefined);
        } else {
            var realData = [];
            var hashTable = {};
            for (var i in results) {
                var doc = results[i];
                if (doc.to == myID) {
                    hashTable[doc.from] = true;
                } else if (doc.from == myID) {
                    hashTable[doc.to] = true;
                }
            }
            for (var key in hashTable) {
                realData.push(key);
            }
            callback({data: realData, time: date});
        }
    });
}