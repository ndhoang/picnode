require 'coffee-script'
require 'express-namespace'

#config   = require './apps/config'
express  = require('express')
http     = require('http')

app = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views';
  app.set 'view engine', 'jade'

  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use require('connect-assets')()
  app.use express.static "#{__dirname}/public"
  app.use express.logger()

require('./apps/mobile/routes')(app)
server = app.listen(app.settings.port)


