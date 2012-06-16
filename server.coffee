fs = require 'fs'
path = require 'path'
express = require 'express'
mustache = require 'mustache'
stitch = require 'stitch'


# Config
projectPath = process.cwd()
projectName = path.basename projectPath.toLowerCase()
buildDir = 'build'
buildFile = projectName
buildFile += '.js' if projectName.substr(projectName.length - 3) != '.js'
buildPath = path.join buildDir, buildFile
buildUrl = '/build/' + buildFile


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
    script: buildUrl
    width: 800
    height: 600


app.get buildUrl, (req, res) ->
  fs.unlinkSync buildPath
  console.log 'Building ' + buildFile + '...'
  p = stitch.createPackage
    paths: [projectPath]
  p.compile (err, source) ->
    throw err if err
    source += "require('main')\n"
    fs.writeFileSync buildPath, source, 'utf8'
    console.log 'Done!'
    res.contentType buildPath
    res.send sendFile buildPath


# Helpers
sendFile = (path) ->
  fs.readFileSync path, 'utf8'
