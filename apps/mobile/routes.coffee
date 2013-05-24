request = require 'request'

routes = (app, passport) ->
  app.post '/', (req, res) ->
    res.redirect '/'
  app.get '/', (req, res) ->
    opts = 
      uri: 'http://picmul.herokuapp.com/titles'
      method: 'GET'
      followRedirect: true
      maxRedirects: 10
      timeout: 10000

    request opts, (err, response, body) ->
      data = JSON.parse body
      values =
        data: data
      res.render 'index', values

  app.get '/show/:id', (req, res) ->
    id = req.params.id
    opts =
      uri: "http://picmul.herokuapp.com/show/#{id}"
      method: 'GET'
      followRedirect: true
      maxRedirects: 10
      timeout: 10000
    request opts, (err, response, body) ->
      #console.log body
      body = body.replace('<html>', '')
      body = body.replace('<head>', '')
      body = body.replace('</head>', '')
      body = body.replace('<body>', '')
      body = body.replace('\\n', '')
      body = body.replace('&gt;&gt;', '')
      body = body.replace('&lt;&lt;', '')
      data = JSON.parse body
      
      values =
        title: data.title
        content: data.content
      res.render 'show', values
      #res.json values

  app.get '/fb', (req, res) ->
    res.json {success: true, user: req.user._json}

  #app.get '/account', ensureAuthenticated, (req, res) ->
  #  res.json req.user

  app.get '/login', (req, res) ->
    res.render 'login', {user: req.user}

  app.get '/auth/facebook', passport.authenticate 'facebook', (req, res) ->
    #pass

  app.get '/auth/facebook/callback', passport.authenticate('facebook', {failureRedirect: '/login'}), (req, res) ->
    console.log 'aaa', req.user
    values =
      success: req.isAuthenticated()
      user: req.user._json

    res.json values
    #res.redirect '/fb'

  ensureAuthenticated = (req, res, next) ->
    if req.isAuthenticated()
      return next
    res.redirect '/login'


module.exports = routes