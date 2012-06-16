fs = require 'fs'
path = require 'path'
express = require 'express'
mustache = require 'mustache'
uglyfyJS = require 'uglify-js'


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
    script: buildPath
    width: 800
    height: 600


app.get buildUrl, (req, res) ->
  console.log 'Building ' + buildFile + '...'
  build 'main.js', buildPath
  console.log 'Done!'
  res.contentType buildPath
  res.send sendFile buildPath


# Helpers
sendFile = (path) ->
  fs.readFileSync path, 'utf8'


build = (sourcePath, destPath) ->
  src = fs.readFileSync sourcePath, 'utf8'
  # TODO: combine commonJS files
  ast = uglyfyJS.parser.parse src
  ast = uglyfyJS.uglify.ast_mangle ast
  ast = uglyfyJS.uglify.ast_squeeze ast
  out = uglyfyJS.uglify.gen_code ast
  fs.writeFileSync destPath, out, 'utf8'
