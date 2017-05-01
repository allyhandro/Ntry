const mongoose = require('mongoose'),
    URLSlugs = require('mongoose-url-slugs');
const bcrypt = require('bcryptjs');

/* Client Schema
    - users have multiple clients
    - clients can have multiple items
*/
const clientSchema = new mongoose.Schema({
    name: {type: String},
    phone: {type: String},
    email: {type: String},
    rent: {type: Number},
    rate: {type: Number},
});

module.exports = mongoose.model('Client', clientSchema);