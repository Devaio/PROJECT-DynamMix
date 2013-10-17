/*
 * GET home page.
 */

exports.login = function(req, res){
	username = req.body.username || undefined;
	req.session.username = username
	res.redirect('/'+username)
}

exports.index = function(req, res){
	username = req.body.username || undefined;
	req.session.username = username
  res.render('index', { title: 'DynamMix', username : username });
};
