// from http://www.iosinsight.com/backend-rest-api-nodejs/
const express = require('express');
const router = express.Router();
const Item = require('../models/item');
const Client = require('../models/client');
// const mongoose = require('mongoose');
// require('../db');
// const Item = mongoose.model('Item');

// Middleware to log all api requests
router.use(function timeLog(req, res, next) {
    console.log('Request Received: ', dateDisplayed(Date.now()));
    next();
});

router.get('/', (req, res)=>{
    res.json({message: "Welcome to 'Ntry's REST API!"});
});

// find all clients
router.route('/clients/_find')
    .get(function(req, res) {
        Client.find(function(err, clients) {
            if (err) res.send (err);
            res.json(clients);
        });
    });

// find all items
router.route('/items/_find')
    .get(function(req, res) {
        Item.find(function(err, items) {
            if (err) res.send(err);
            res.json(items);
        });
    });

// find item matching item_id
router.route('/items/:item_id/_findOne')
    .get(function(req, res){
        Item.findById(req.params.item_id, function (err, item) {
            if (err) res.send(err);
            res.json({"item": item});
        });
    });

// find item and update with body text
router.route('/items/:item_id/_move')
    .put(function (req, res) {
        Item.findById(req.params.item_id, function (err, item) {
            if (err) res.send(err);
        item.location = req.body.location;
        console.log(item.location);
            item.save(function(err){
                if(err) res.send(err);
                res.json({message: 'item updated', item: item});
            });
        })
    });

// find item and toggle the current status
router.route('/items/:item_id/_check_in_out')
    .put(function (req, res) {
        Item.findById(req.params.item_id, function (err, item) {
            if (err) res.send(err);
            var message = '';
            if (item.status === 'in'){
                item.status = 'out';
                message = item.title + ' checked out.';
            } else if (item.status === 'out'){
                item.status = 'in';
                message = item.title + ' checked in.';
            }
            item.save(function(err){
                if(err) res.send(err);
                res.json({message: message});
            });
        })
    });


module.exports = router;

// formats time for logger
function dateDisplayed(timestamp){
    var date = new Date(timestamp);
    return (date.getMonth() + 1 + '/' + date.getDate() + '/' +  date.getFullYear() +
     " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds());
}