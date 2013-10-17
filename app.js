/**
 * Module dependencies.
 */

var express = require('express');
var router = require('./routes/router');
var http = require('http');
var path = require('path');
var flash = require('connect-flash');
var scripts = require(__dirname + '/public/javascripts/scripts.js');
var app = express();
var passport = require('passport'),
	FacebookStrategy = require('passport-facebook').Strategy;

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.cookieParser('your secret here'));
app.use(express.session());
app.use(passport.initialize());
app.use(passport.session());
app.use(app.router);
app.use(require('stylus').middleware(__dirname + '/public'));
app.use(express.static(path.join(__dirname, 'public')));


// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

app.configure(function() {
  app.use(express.cookieParser('keyboard cat'));
  app.use(express.session({ cookie: { maxAge: 60000 }}));
  app.use(flash());
});

app.get('/', router.index);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});

app.post('/login',
  passport.authenticate('local',
	{ successRedirect: '/',
	failureRedirect: '/login' }
	));

passport.use(new FacebookStrategy({
    clientID: 439594016145506,
    clientSecret: 'ad6298f9c42943e2775163bd4f64d589',
    callbackURL: "http://www.dynammix.io/auth/facebook/callback"
  },
  function(accessToken, refreshToken, profile, done) {
    User.findOrCreate(
		{ id : id,
		name : name}, function(err, user) {
      if (err) { return done(err); }
      done(null, user);
    });
  }
));

app.get('/auth/facebook',
	passport.authenticate('facebook')
	);

app.get('/auth/facebook/callback',
	passport.authenticate('facebook',
		{ successRedirect: '/',
		failureRedirect: '/login'
	}));


// need local authentication for usernames/passwords created on the site
// app.post('/login', 
//   passport.authenticate('local', { failureRedirect: '/login' }),
//   function(req, res) {
//     res.redirect('/:username');
//   });












