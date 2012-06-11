fs = require 'fs'
path = require 'path'
express = require 'express'
mustache = require 'mustache'


# Config
entryFile = 'main.js'


# The web application
app = express.createServer express.static(__dirname + '/static')
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
    entry: entryFile
    width: 800
    height: 600


app.get '/workspace/*', (req, res) ->
  res.send sendFile req.params[0]


# Helpers
sendFile = (path) ->
  fs.readFileSync path, 'utf8'
