const express = require('express');
const router = express.Router();
// const mongoose = require('mongoose');
// require('../db');
const User = require('../models/user');
const Client = require('../models/client');
const Item = require('../models/item');
const qrCode = require('qrcode');

// quic styling
router.get('/item-to-client', function (req, res){
    res.render('itemToClient.hbs', {layout: 'userLayout', client: 'John Snow'});
});

// homepage
router.get('/', function (req, res){
    res.render('index', {layout: 'layout'});
});

// about
router.get('/about', function (req, res){
    res.render('about', {layout: 'layout'});
});

router.get('/register-client', ensureAuthenticated, function (req, res){
    res.render('newClient', {layout:'userLayout'});
});
// mobile app information
router.get('/mobile', function (req, res){
    res.render('mobile', {layout: 'layout'});
});

router.get('/print-labels', function (req, res){
    const clientName = req.cookies.clientName;
    Client.findOne({name: req.cookies.clientName}, (err, client)=>{
        if (err){
            console.log(err);
        } else {
            const items = [];
            Item.find({client_id: client._id}, (err, items) =>{
                if (err){
                    console.log(err);
                } else {
                    for (var j = 0; j < items.length; j++){
                        const item = {};
                        item['id'] = items[j].id;
                        item['title'] = items[j].title;
                        item['location'] = items[j].location;
                    }
                    res.render('labels', {layout:'userLayout', item: items, clientName: clientName});
                }
            });
        }
    });
});

router.get('/register-items', ensureAuthenticated, function(req, res){
    res.render('itemToClient', {layout:'userLayout'});
});

router.post('/register-items', ensureAuthenticated, function (req, res){
    const client_id = req.cookies.clientId;
    const items = req.body;
    var sqFt = 0;
    items.forEach((item) => {
        const newItem = new Item({
            client_id: client_id,
            title: item.title,
            artist: item.artist,
            description: item.description,
            dimension: [item.dimensions[0], item.dimensions[1], item.dimensions[2]],
            type: items.type,
            status: 'in',
            packing: item.packing,
            location: item.location
        }).save((err, item, count)=>{
            if (err){
                console.log(err);
            }
        });
        sqFt += item.dimensions[0] * item.dimensions[1];
    });
    Client.findOne({name: req.cookies.clientName}, (err, client, count) =>{
            if (err){
                console.log(err);
            } else {
                const rent = client.rate * sqFt;
                Client.update({name: req.cookies.clientName},
                  {$set: {rent: rent}},(err, data) =>{
                    if (err){
                        console.log(err);
                        return res.status(500).send(err);
                    }
                    return res.status(200).send(data);
                });
            }
    });
});

//////////////////////////////////
// User Portal Routes
//////////////////////////////////
router.get('/register', ensureAuthenticated, function (req, res){
    res.render('userPortal', {layout:'userLayout'});
});

router.get('/find', ensureAuthenticated, function (req, res){
    const userRes = [];
    User.findOne({'_id': req.cookies.userId}, (err, user, count) =>{
        if(err){
            console.log("from user find" + err);
        } else {
            user.clients.forEach((clientId) => {
                Client.findOne({'_id': clientId}, (err, client) =>{
                    if (err){
                        console.log("from client find" + err);
                    } else {
                        userRes.push(client.name);
                    }
                });
            });
            res.render('find', {layout:'userLayout', res: userRes});
        }
    });
});

router.post('/:client/items',ensureAuthenticated, function(req, res){
    res.cookie('clientName', req.body.clientName);
    res.render('clientItems', {layout:'userLayout', clientName: req.body.clientName});
});

router.get('/:client/items', ensureAuthenticated, function (req, res) {
    const itemList = [];
    Client.findOne({name: req.cookies.clientName}, (err, client) => {
        if (err){
            console.log(err);
        } else{
            Item.find({client_id: client._id}, (err, items) =>{
                if (err){
                    console.log(err);
                }else {
                    for (var i = 0; i < items.length; i++){
                        console.log(items[i].title);
                        itemList.push(items[i].title);
                    }
                    res.render('clientItems', {layout:'userLayout', clientName: req.cookies.clientName, item: itemList});
                }
            });
        }
    });
});

router.get('/user-portal/:username', ensureAuthenticated, function (req, res){
    User.findOne({slug: req.params.slug}, (err, user, count) =>{
        if (err){
            res.render('error', {'error': error});
        } else {
            res.render('userPortal', {layout: 'userLayout'});
        }
    });
});

router.post('/register-client', ensureAuthenticated, function (req, res){
    const name = req.body.name;
    const phone = req.body.phone;
    const email = req.body.email;
    const rate = req.body.rate;
    req.checkBody('name', 'Name is required').notEmpty();
    req.checkBody('phone', 'Phone is required').notEmpty();
    req.checkBody('email', 'Invalid Email').isEmail();
    req.checkBody('email', 'Email is required').notEmpty();
    req.checkBody('rate', 'Rate is required.').notEmpty();

    const errors = req.validationErrors();
    if (errors){
        res.render('newClient', {layout: 'userLayout', errors:errors});
    } else {
        if (req.cookies.userId.match(/^[0-9a-fA-F]{24}$/)){
            const newClient = new Client({
                        name: req.body.name,
                        phone: req.body.phone,
                        email: req.body.email,
                        rent: 0,
                        rate: req.body.rate,
                        items: []
            });
            newClient.save((err, client, count)=>{
                if (err){
                    res.render('error', {layout: 'userLayout', 'error':err});
                }
            });
            User.findOneAndUpdate({'_id': req.cookies.userId},
                {$push: {clients: newClient}}, (err, user, count) =>{
                    if (err){
                        res.render('error', {'error': err});
                    } else {
                        res.cookie('clientName', newClient.name);
                        res.cookie('clientId', newClient._id);
                        res.render('itemToClient', {layout: 'userLayout', client: newClient.name});
                    }
            });
        } else {
            res.redirect('/users/login');
        }
    }
});


// reduce use x 1
function calculateRent(items, clientRate){
    const sqrFootage = items.reduce((acc, item) =>{
        return acc + (item.dimension[0] * item.dimension[1]);
    });
    return sqrFootage * clientRate;
}

function ensureAuthenticated(req, res, next){
    if (req.isAuthenticated()){
        return next();
    } else {
        req.flash('error_msg', 'Please log in to view this content.');
        res.redirect('/users/login');
    }
}

module.exports = router;