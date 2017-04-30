// Express
const express = require('express');
const app = express();

// Path
const path = require('path');
const publicPath = path.resolve(__dirname, 'public');

// View Engine
app.use(express.static(publicPath));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');

// set MIME types for icons
app.use('/fonts', express.static('./node_modules/font-awesome/css'));
app.use('/fonts', express.static('./node_modules/font-awesome/fonts'));
// express.mime.type['.eot'] = 'application/vnd.ms-fontobject';
// express.mime.type['.woff'] = 'application/font-woff';
// express.mime.type['.ttf'] = 'application/x-font-truetype';
// express.mime.type['.svg'] = 'application/image/svg+xml';
// express.mime.type['.otf'] = 'application/x-font-opentype';


// from https://github.com/bradtraversy/loginapp/blob/master/app.js
const cookieParser = require('cookie-parser');
const flash = require('connect-flash');
const session = require('express-session');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const expressValidator = require('express-validator');


// Mongo / MongoDB
require('./db');
const mongoose = require('mongoose');
const User = mongoose.model('User');
const Client = mongoose.model('Client');

const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());
app.use(cookieParser());

// Express Session
app.use(session({
    secret: 'secret',
    saveUninitialized: true,
    resave: true
}));

// Passport init
app.use(passport.initialize());
app.use(passport.session());


// Express Validator
app.use(expressValidator({
  errorFormatter: function(param, msg, value) {
      var namespace = param.split('.')
      , root    = namespace.shift()
      , formParam = root;

    while(namespace.length) {
      formParam += '[' + namespace.shift() + ']';
    }
    return {
      param : formParam,
      msg   : msg,
      value : value
    };
  }
}));

// Connect Flash
app.use(flash());

// global variable for flash
app.use(function (req, res, next) {
  res.locals.success_msg = req.flash('success_msg');
  res.locals.error_msg = req.flash('error_msg');
  res.locals.error = req.flash('error');
  res.locals.user = req.user || null;
  next();
});

// Routes
const routes = require('./routes/index');
const users = require('./routes/users');
app.use('/', routes);
app.use('/users', users);


// Set Port
app.set('port', (process.env.PORT || 5000));
app.listen(app.get('port'), function(){
    console.log('Node app is running on port', app.get('port'));
});



