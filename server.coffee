fs = require 'fs'
url = require 'url'
http = require 'http'
mustache = require 'mustache'
crossroads = require 'crossroads'


crossroads.addRoute '/', ->
  render_template 'templates/index.html', { width: 800, height: 600, entry: 'main.js' }


exports.server = http.createServer (request, response) ->
  #response.writeHead 200, {'Content-Type': 'text/html; charset=utf-8'}
  #response.end render_template('templates/index.html', { width: 800, height: 600, entry: 'main.js' })
  console.log(crossroads.parse url.parse(request.url).pathname)


render_template = (template_file, model) ->
  mustache.to_html fs.readFileSync('templates/index.html', 'ascii'), model
