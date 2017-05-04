const mongoose = require('mongoose'),
    URLSlugs = require('mongoose-url-slugs');
const bcrypt = require('bcryptjs');


/* an art piece of a client
    - each item must have a client it belongs to
*/
const itemSchema = new mongoose.Schema({
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

module.exports = mongoose.model('Item', itemSchema);