app = require('./server').app

# TODO: use command-line arguments
port = 8080

app.listen port
console.log 'Server running at http://127.0.0.1:' + port + '/'
