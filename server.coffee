express = require 'express'
mustache = require 'mustache'


# The web application
app = express.createServer()
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
