/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'DynaTune' });
};

exports.login = function(req, res){
	username = req.body.username || "Anonymous";
	req.session.username = username
	res.redirect('/'+username)
}

exports.loggedIn = function(req, res){
	res.render('userinfo', { username : username, title: 'DynaTune' }) 
}