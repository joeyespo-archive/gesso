var gesso = require('gesso');
var canvas = gesso.canvas;
var context = canvas.getContext('2d');

context.font = 'normal 36px Verdana';
context.fillStyle = '#000000';
context.fillText('Hello from Gesso!', 240, 100);
