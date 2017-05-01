const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
require('../db');
const Item = mongoose.model('Item');

router.get('/', (req, res)=>{
    res.render('index', {layout:'layout'});
});
module.exports = router;