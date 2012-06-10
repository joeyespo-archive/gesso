fs = require 'fs'
express = require 'express'
mustache = require 'mustache'


# The web application
exports.app = app = express.createServer()


# Views
app.get '/', (req, res) ->
  res.send render_template 'templates/index.html', { width: 800, height: 600, entry: 'main.js' }


# Helpers
render_template = (template_file, model) ->
  mustache.to_html fs.readFileSync(template_file, 'ascii'), model
