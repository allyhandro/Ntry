
const mongoose = require('mongoose'),
    URLSlugs = require('mongoose-url-slugs');
const bcrypt = require('bcryptjs');

var url = process.env.MONGOLAB_URI;

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
/* Client Schema
    - users have multiple clients
    - clients can have multiple items
*/
const Client = new mongoose.Schema({
    name: {type: String},
    phone: {type: String},
    email: {type: String},
    rent: {type: Number},
    rate: {type: Number},
});


/* an art piece of a client
    - each item must have a client it belongs to
*/
const Item = new mongoose.Schema({
    client_id:{type: mongoose.Schema.Types.ObjectId, ref: 'Client'},
    title: {type: String, required: true},
    artist: {type: String},
    description: {type: String},
    dimension: [{type: Number}],
    type: {type: String},
    status: {type: String, enum: ['in', 'out']},
    packing: {type: String},
    // ref https://gist.github.com/aheckmann/2408370
    // image: {data: Buffer, contentType: String},
    location: {type: String}
    // history: [{
    //     status: {type: String, enum: ['in', 'out']},
    //     date: Date
    // }]
});


/* a Location in the user's inventory named Place b/c keyword Location
*/
const Place = new mongoose.Schema({
    name: {type: String, required: true},
    item: {type: mongoose.Schema.Types.ObjectId, ref: 'User'}
});

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


mongoose.model('Client', Client);
mongoose.model('Item', Item);
mongoose.model('Place', Place);
mongoose.Promise = global.Promise;

mongoose.connect(url, function(err, db){
    if (err){
        console.log('Unable to connect to server...');
        console.log(err);
    } else {
        console.log('connection established to ' + url);
    }
});
