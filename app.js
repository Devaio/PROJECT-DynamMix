
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
var passport = require('passport'), LocalStrategy = require('passport-local').Strategy;

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

app.get('/', router.index);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});


app.post('/login',
	passport.authenticate('local',
		{ successFlash: req.flash('Welcome!'),
		failureFlash: req.flash('Invalid username or password.')
	}),
	function(req, res){
		res.redirect('/users' + req.user.username);
	});

passport.use(new LocalStrategy(
  function(username, password, done) {
    User.findOne({ username: username }, function(err, user) {
      if (err) { return done(err); }
      if (!user) {
        return done(null, false, { message: 'Incorrect username.' });
      }
      if (!user.validPassword(password)) {
        return done(null, false, { message: 'Incorrect password.' });
      }
      return done(null, user);
    });
  }
));

