/**
 * Created by wanglongyan on 15/6/10.
 */

var mongoose = require('mongoose');

var userSchema = mongoose.Schema({
    name: String,
    password: String
});

var friendSchema = mongoose.Schema({
    fromID : String,
    toID : String,
    status : String //waiting,allowed
});

friendSchema.methods.add = function (callback) {
    this.save(function(error) {
        callback(error);
    });
};


exports.userModel = mongoose.model('users', userSchema);
exports.friendModel = mongoose.model('friends', friendSchema);

exports.checkLogin = function (name, password, callback) {
    var check = new exports.userModel({name:name, password: password});
    exports.userModel.find({name : name, password:password}, function(err, users){
        if (users.length == 1) {
            var retUser = {};
            retUser.name = users[0].name;
            retUser.id = users[0]._id;
            retUser.session = users[0]._id;
            callback(retUser);
        } else {
            callback(undefined);
        }
    });
};

exports.getUserBriefInfo = function (userIDs, callback) {
    var condition = [];
    for (var i in userIDs) {
        condition[i] = {_id:userIDs[i]};
    }
    exports.userModel.find({$or:condition}).exec(function(err, results) {
        if (err) {
            callback(undefined);
        } else {
            for (var i in results) {
                results[i].password = "";
            }
            callback(results);
        }
    });
};

exports.addFriend = function (friendID, myID, callback) {

    exports.friendModel.find({fromID: myID, toID:friendID}, function(err2, results2) {
        if (results2.length > 0) {
            callback(results2[0]);
        } else {
            var add = new exports.friendModel({
                fromID: myID,
                toID: friendID,
                status: 'waiting'
            });
            add.add(function (error) {
                if (error) {
                    callback(undefined);
                } else {
                    callback(add);
                }
            });
        }
    });

    //2 conditions: 1.add someone as friend  2.allow someone add require
    if (false) {
        exports.friendModel.find({fromID: friendID, toID:myID}, function(err, results) {
            if (results.length == 1) {
                if(results.status == 'waiting') {
                    //condition 2: some one added me, I allow the requirement.
                    var r = results[0];
                    r.status = 'allowed';
                    //update item to update status...
                    exports.friendModel.update(r._id, r, function(err, updateResults) {
                        if (updateResults.length) {
                            //update the request's status
                            //and add another one as "my friends"
                            var add = exports.friendModel({
                                fromID: myID,
                                toID: friendID,
                                status: 'allowed'
                            });
                            add.save(function (error) {
                                if (error) {
                                    callback(undefined);
                                } else {
                                    callback(add);
                                }
                            });
                        } else {
                            callback(undefined);
                        }
                    });
                } else {
                    callback(undefined);
                }
            } else {
                //condition 2: add some one new.

                //first, check duplicate.
                exports.friendModel.find({fromID: myID, toID:friendID}, function(err2, results2) {
                    if (results2.length > 0) {
                        callback(results2[0]);
                    } else {
                        var add = new exports.friendModel({
                            fromID: myID,
                            toID: friendID,
                            status: 'waiting'
                        });
                        add.add(function (error) {
                            if (error) {
                                callback(undefined);
                            } else {
                                callback(add);
                            }
                        });
                    }
                });
            }
        });
    }
};


exports.getFriendList = function (myID, callback) {
    //目前是单向好友，waiting即可，没有allowed
    var condition = {};
    condition = {fromID:myID, status:'waiting'};
    exports.friendModel.find(condition).sort({'status':-1}).exec(function(err, results) {
        if (err) {
            callback(undefined);
        } else {
            var index = 0;
            if (results.length > 0) {
                for (var i in results) {
                    //find names
                    exports.userModel.findOne({_id:results[i].toID}).exec(function(err, res) {
                        results[index]._doc.name = res.name;
                        index ++;
                        if (index == results.length) {
                            callback(results);
                        }
                    });
                }
            } else {
                callback(results);
            }
        }
    });

    return;
    var condition = {};
    condition = {$or: [{fromID:myID, status:'allowed'}, {toID:myID, status:'waiting'}]};
    exports.friendModel.find(condition).sort({'status':-1}).exec(function(err, results) {
        if (err) {
            callback(undefined);
        } else {
            callback(results);
        }
    });
};

exports.searchFriend = function (targetID, callback) {
    var query = {};
    query['name']=new RegExp(targetID);
    exports.userModel.find(query, function(err, results) {
        if (err) {
            callback(undefined);
        } else {
            for (var i in results) {
                results[i].password = "";
            }
            callback(results);
        }
    });
};