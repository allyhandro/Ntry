const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
require('../db');
const Client = mongoose.model('Client');
const User = mongoose.model('User');

// Register new user
router.get('/new-user', function (req, res){
    res.render('newUser', {layout: 'layout'});
});

// from youtube Traversy Media Node.js Login System With Passport
// takes form input, validates, then parses to db
router.post('/new-user', function (req, res){
    const name = req.body.name;
    const email = req.body.email;
    const username = req.body.username;
    const password = req.body.password;
    const password2 = req.body.password2;

    // validation
    req.checkBody('name', 'Name is required').notEmpty();
    req.checkBody('email', 'Email is required').notEmpty();
    req.checkBody('email', 'Email is not valid').isEmail();
    req.checkBody('username', 'Username is required').notEmpty();
    req.checkBody('password', 'Password is required').notEmpty();
    req.checkBody('password2', 'Passwords do not match').equals(req.body.password);

    let errors = req.validationErrors();

    if (errors){
        res.render('newUser', {errors: errors});
    } else {
        const newUser = new User({
            name: name,
            email: email,
            username: username,
            password: password,
            clients: []
        });

        User.createUser(newUser, function (err, user){
            if(err) throw err;
        });

        req.flash('success_msg', 'You are registered!');
        res.redirect('/users/login');
    }
});

/////////////////////////////////////////////
// passport middleware for authentication
passport.use(new LocalStrategy(
    function (username, password, done) {
        User.getUserByUsername(username, function (err, user){
            if (err) throw err;
            if (!user){
                return done(null, false, {message: 'Unknown User'});
            }
            User.comparePassword(password, user.password, function (err, isMatch) {
                if (err) throw err;
                if (isMatch){
                    return done(null, user);    // its a match!
                } else {
                    return done(null, false, {message: 'Invalid password'});
                }
            });
        });
    }));

passport.serializeUser(function (user, done) {
    done(null, user.id);
});

passport.deserializeUser(function (id, done) {
    User.getUserById(id, function(err, user) {
        done(err, user);
    });
});
/////////////////////////////////////////////

// Login routers
router.get('/login', function (req, res){
    res.render('login', {'errors': req.message});
});

// authenticates input, redirects to user's homepage (/userslug)
router.post('/login', passport.authenticate('local', {failureRedirect:'/users/login', failureFlash: true}),
    function (req, res) {
        User.getUserByUsername(req.body.username, function (err, user){
            if (err){
                res.render('login', {'errors': err});
            } else {
                res.cookie('userId', user._id);
                res.redirect('/' + user.slug);
            }
        });
    });

// Logout
router.get('/logout', function (req, res){
    req.logout();
    req.flash('success_msg', 'You are logged out.');
    res.redirect('/');
});


module.exports = router;