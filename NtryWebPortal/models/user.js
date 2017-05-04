const mongoose = require('mongoose'),
    URLSlugs = require('mongoose-url-slugs');
const bcrypt = require('bcryptjs');

/* User Schema
    - requires authentication
    - users have username and password
    - can have 0 or more items
*/
const UserSchema = new mongoose.Schema({
    username: {type: String, index: true},   // filled for now, but will be provided by authentication
    password: {type: String},//Hash,     // password to be provided by authentication
    email: {type: String},
    name: {type: String},
    clients: [{type: mongoose.Schema.Types.ObjectId, ref: 'Client'}]
});

UserSchema.plugin(URLSlugs('username'));

const User = module.exports = mongoose.model('User', UserSchema);
module.exports.createUser = function(newUser, callback){
    // use bcrypt to hash password
    bcrypt.genSalt(10, function (err, salt) {
        bcrypt.hash(newUser.password, salt, function (err, hash){
            newUser.password = hash;
            newUser.save(callback);
        });
    });
}

module.exports.getUserByUsername = function(username, callback){
    const query = {username: username};
    User.findOne(query, callback);
}

module.exports.comparePassword = function (candidatePassword, hash, callback) {
    bcrypt.compare(candidatePassword, hash, function (err, isMatch) {
        if (err) throw err;
        callback(null, isMatch);
    });
}

module.exports.getUserById= function(id, callback){
    User.findById(id, callback);
}
