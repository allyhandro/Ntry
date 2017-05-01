// from http://www.iosinsight.com/backend-rest-api-nodejs/
const express = require('express');
const router = express.Router();
const Item = require('../models/item');
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

module.exports = router;

// formats time for logger
function dateDisplayed(timestamp){
    var date = new Date(timestamp);
    return (date.getMonth() + 1 + '/' + date.getDate() + '/' +  date.getFullYear() +
     " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds());
}