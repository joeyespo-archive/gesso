fs = require 'fs'
path = require 'path'
express = require 'express'
mustache = require 'mustache'


# Config
requirejs = path.join __dirname, 'node_modules', 'requirejs', 'require.js'


# The web application
app = express.createServer()
app.use '/static', express.static(__dirname + '/static')
app.set 'views', path.join(__dirname, 'views')
app.set 'view options',
  layout: false
app.register '.html',
  compile: (source, options) ->
    (locals) ->
      mustache.to_html source, locals
exports.app = app


# Views
app.get '/', (req, res) ->
  res.render 'index.html',
    entry: 'main.js'
    width: 800
    height: 600


app.get '/workspace/*', (req, res) ->
  path = req.params[0]
  contents = sendFile path
  res.contentType path
  res.send contents


# Overrides
app.get '/static/require.js', (req, res) ->
  res.contentType requirejs
  res.send sendFile requirejs


# Helpers
sendFile = (path) ->
  fs.readFileSync path, 'utf8'
