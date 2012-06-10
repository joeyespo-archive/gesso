server = require('./server').server


# TODO: use command-line arguments

server.listen 80
console.log 'Server running at http://127.0.0.1/'
