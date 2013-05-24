require 'coffee-script'
require 'express-namespace'

#config   = require './apps/config'
express  = require('express')
http     = require('http')
passport = require 'passport'
FacebookStratey = require('passport-facebook').Strategy
app = express()

FACEBOOK_APP_ID = '378328998953452'
FACEBOOK_APP_SECRET = '04209991da9f85802a67799aa0ce6383'
#CALLBACK_URL = 'http://localhost:3000/auth/facebook/callback'
CALLBACK_URL = 'http://picmul.com/auth/facebook/callback'

passport.serializeUser (user, done) ->
  done null, user
passport.deserializeUser (obj, done) ->
  done null, obj

opts = 
  clientID: FACEBOOK_APP_ID
  clientSecret: FACEBOOK_APP_SECRET
  callbackURL: CALLBACK_URL
passport.use(new FacebookStratey opts, (accessToken, refreshToken, profile, done) -> 
  process.nextTick () ->
    return done null, profile
)

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views';
  app.set 'view engine', 'jade'

  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use require('connect-assets')()
  app.use express.static "#{__dirname}/public"
  app.use express.logger()

  app.use(passport.initialize())
  app.use(passport.session())

require('./apps/mobile/routes')(app, passport)
server = app.listen(app.settings.port)


