module.exports = ->
	
	# Require all modules for a minimal webserver
	express = require 'express'
	morgan = require 'morgan'
	errorHandler = require 'express-error-handler'
	fs = require 'fs'

	# Create express application
	app = express()

	# Setting application port
	app.set 'port', process.env.PORT || 3000

	# Use error-handler in dev mode
	app.use errorHandler() if 'development' is app.get 'env'
	
	# Set up logging in file
	accessLogStream = fs.createWriteStream __dirname + '/../access.log', flags: 'a'
	app.use morgan 'combined', stream: accessLogStream

	# Set up static file server
	app.use express.static __dirname + '/../public'

	# Run webserver
	console.log '[>] Starting webserver on port ' + app.get 'port'
	server = app.listen app.get 'port'

	# Attach socket.io to express
	io = require 'socket.io'
					.listen server

	# Include io server
	ioserver = require './server.js'
	ioserver(io)