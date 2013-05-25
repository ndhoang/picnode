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
      timeout: 20000

    request opts, (err, response, body) ->
      try
        data = JSON.parse body
        values =
          data: data
        res.render 'index', values
      catch err
        console.log 'error found index', err

  app.get '/show/:id', (req, res) ->
    id = req.params.id
    opts =
      uri: "http://picmul.herokuapp.com/show/#{id}"
      method: 'GET'
      followRedirect: true
      maxRedirects: 10
      timeout: 20000
    request opts, (err, response, body) ->
      #console.log body
      body = body.replace('<html>', '')
      body = body.replace('<head>', '')
      body = body.replace('</head>', '')
      body = body.replace('<body>', '')
      body = body.replace('\\n', '')
      body = body.replace('&gt;&gt;', '')
      body = body.replace('&lt;&lt;', '')

      try
        data = JSON.parse body
      
        values =
          title: data.title
          content: data.content
        res.render 'show', values
      catch err
        console.log 'err raised', err

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
    #console.log 'aaa', req.user
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