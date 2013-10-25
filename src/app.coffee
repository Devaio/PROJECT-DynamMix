###
Module dependencies.
###

# all environments
findById = (id, fn) ->
	idx = id - 1
	if users[idx]
		fn null, users[idx]
	else
		fn new Error("User " + id + " does not exist")
findByUsername = (username, fn) ->
	i = 0
	len = users.length

	while i < len
		user = users[i]
		return fn(null, user)  if user.username is username
		i++
	fn null, null
express = require("express")
http = require("http")
path = require("path")
flash = require("connect-flash")
app = express()
passport = require("passport")
FacebookStrategy = require("passport-facebook").Strategy
LocalStrategy = require("passport-local").Strategy
LastFmNode = require("lastfm").LastFmNode
lastfm = new LastFmNode(
	api_key: "1805293d5e058d03761b53547ec0ad74"
	secret: "ff65671f88c114e3752236f465566c67"
)
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/../views"
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser("your secret here")
app.use express.session()
app.use passport.initialize()
app.use passport.session()
app.use app.router
app.use require("stylus").middleware(__dirname + "/public")
app.use express.static(path.join(__dirname, "public"))
users = [
	id: 1
	username: "bob"
	password: "secret"
	email: "bob@example.com"
,
	id: 2
	username: "joe"
	password: "birthday"
	email: "joe@example.com"
]

# Passport session setup.
#   To support persistent login sessions, Passport needs to be able to
#   serialize users into and deserialize users out of the session.  Typically,
#   this will be as simple as storing the user ID when serializing, and finding
#   the user by ID when deserializing.
passport.serializeUser (user, done) ->
	done null, user.id

passport.deserializeUser (id, done) ->
	findById id, (err, user) ->
		done err, user



# Use the LocalStrategy within Passport.
#   Strategies in passport require a `verify` function, which accept
#   credentials (in this case, a username and password), and invoke a callback
#   with a user object.  In the real world, this would query a database;
#   however, in this example we are using a baked-in set of users.
passport.use new LocalStrategy (username, password, done) ->
	
	# asynchronous verification, for effect...
	process.nextTick ->
		
		# Find the user by username.  If there is no user with the given
		# username, or the password is not correct, set the user to `false` to
		# indicate failure and set a flash message.  Otherwise, return the
		# authenticated `user`.
		findByUsername username, (err, user) ->
			return done(err)  if err
			unless user
				return done(null, false,
					message: "Unknown user " + username
				)
			unless user.password is password
				return done(null, false,
					message: "Invalid password"
				)
			done null, user

# development only
app.use express.errorHandler()  if "development" is app.get("env")
app.configure ->
	app.use express.cookieParser("keyboard cat")
	app.use express.session(cookie:
		maxAge: 60000
	)
	app.use flash()

app.get "/", (req, res) ->
	res.render "index",
		firstpage: true
		title: "DynamMix"


http.createServer(app).listen app.get("port"), ->
	console.log "Express server listening on port " + app.get("port")

app.post "/login", passport.authenticate("local",
	successRedirect: "/"
	failureRedirect: "/login"
)
passport.use new FacebookStrategy(
	clientID: 439594016145506
	clientSecret: "ad6298f9c42943e2775163bd4f64d589"
	callbackURL: "http://dynammix.herokuapp.com/auth/facebook/callback"
, (accessToken, refreshToken, profile, done) ->
	User.findOrCreate
		id: id
		name: name
	, (err, user) ->
		return done(err)  if err
		done null, user

)
app.get "/auth/facebook", passport.authenticate("facebook")
app.get "/auth/facebook/callback", passport.authenticate("facebook",
	successRedirect: "/"
	failureRedirect: "/login"
)

# need local authentication for usernames/passwords created on the site
app.post "/login", passport.authenticate("local",
	successRedirect: "/"
	failureRedirect: "/login"
)
trackStream = lastfm.stream("devaio") #add username after stream - dynamic!

#gets most recently played song lastfm
trackStream.on "lastPlayed", (track) ->
	console.log "Last played: " + track.name + " by " + track.artist["#text"] #track name by artist


#gets currently playing song lastfm
trackStream.on "nowPlaying", (track) ->
	console.log "Now playing: " + track.name + " by " + track.artist["#text"]

trackStream.start()

#getting relevant
getRelatedArtists = (getArtist) ->
	relatedArtists = {}
	artist = undefined
	request = lastfm.request("artist.getInfo",
		artist: getArtist
		handlers:
			success: (data) ->
				artist = data.artist.name
				i = 0

				while i < data.artist.similar.artist.length
					relatedArtists[data.artist.similar.artist[i].name] = (data.artist.similar.artist[i].image[3]["#text"])
					i++
				relatedArtists

			error: (error) ->
				console.log "Error: " + error.message
	)
	relatedArtists

app.post "/related", (req, res) ->
	relArtist = getRelatedArtists(req.body.artistSearch)
	setTimeout (->
		res.send
			title: "DynamMix"
			artist: req.body.artistSearch
			relatedArtists: relArtist

	), 1000

app.get "/related", (req, res) ->
	res.render "index",
		artist: req.query.artistSearch

