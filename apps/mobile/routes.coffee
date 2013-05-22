request = require 'request'

routes = (app) ->
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
      data = JSON.parse body
      values =
        title: data.title
        content: data.content
      res.render 'show', values

module.exports = routes