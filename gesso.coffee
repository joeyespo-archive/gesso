app = require('./server').app
try
    config = require('./local_config')
catch e
    config = {}

# TODO: use command-line arguments
port = config.port || 8080

app.listen port
console.log 'Server running at http://127.0.0.1:' + port + '/'
