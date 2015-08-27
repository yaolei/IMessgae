var mongoose = require('mongoose');

var groupSchema = mongoose.Schema({
    name: String,
    member: Array,
    discription: String
});


exports.groupModel = mongoose.model('groups', groupSchema);

exports.getGroupBriefInfo = function(groupID, callback) {

}
