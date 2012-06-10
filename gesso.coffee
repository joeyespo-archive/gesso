app = require('./server').app


# TODO: use command-line arguments

app.listen 80
console.log 'Server running at http://127.0.0.1/'
