fs = require 'fs'
path = require 'path'
express = require 'express'
mustache = require 'mustache'
requirejs = require 'requirejs'


# Config
requireLib = path.join __dirname, 'node_modules', 'requirejs', 'require'


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
    compiled: 'compiled.js'
    width: 800
    height: 600


app.get '/compiled.js', (req, res) ->
  console.log 'Compiling...'
  requirejs.optimize
    baseUrl: '.'
    paths:
      'requireLib': requireLib
    include: 'requireLib'
    name: 'main'
    out: 'compiled.js'
  console.log 'Done!'
  res.contentType 'compiled.js'
  res.send sendFile 'compiled.js'


# Helpers
sendFile = (path) ->
  fs.readFileSync path, 'utf8'
