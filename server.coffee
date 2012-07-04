fs = require 'fs'
path = require 'path'
express = require 'express'
mustache = require 'mustache'
detective = require 'detective'
stitch = require 'stitch'


# Config
projectPath = process.cwd()
projectName = path.basename projectPath.toLowerCase()
buildDir = 'build'
buildFile = projectName
buildFile += '.js' if projectName.substr(projectName.length - 3) != '.js'
buildPath = path.join buildDir, buildFile
buildUrl = '/build/' + buildFile
extensions = ['.js', '.json']
entryModules = ['main']


# The web application
app = express.createServer()
app.use '/static', express.static(path.join(__dirname, 'static'))
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
  console.log 'Building ' + buildFile + '...'
  files = walkModules entryModules, ''
  p = stitch.createPackage
    paths: files
  p.compile (err, source) ->
    throw err if err
    source += "require('main')\n"
    fs.writeFileSync buildPath, source, 'utf8'
    console.log 'Done!'
    res.contentType buildPath
    res.send sendFile buildPath


# Helpers
sendFile = (file) ->
  fs.readFileSync file, 'utf8'


walkModules = (names, currentFile) ->
  names.map (name) ->
    walkModule name, currentFile


walkModule = (name, currentFile) ->
  file = resolve name, currentFile
  if !path.existsSync file
    console.log "\nWarning: No such module '" + file + "'\n      at " + currentFile
    return []
  contents = fs.readFileSync file, 'utf8'
  requires = detective contents
  fileLists = requires.map (name) ->
    walkModule name, file
  fileLists.reduce concat, []


resolve = (name, currentFile) ->
  dir = if currentFile then path.dirname(currentFile) else projectPath
  file = path.join dir, name
  if file.substring(0, projectPath.length) != projectPath
    console.log '\nWarning: A required file is located outside of the project: "' + name + '"\n      at ' + currentFile
  if not path.extname(file)
    for ext in extensions
      if path.existsSync file + ext
        return file + ext
  return name


concat = (a, b) ->
  a.concat b
