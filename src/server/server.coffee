module.exports = (io) ->

	# Include User model
	User = require './user'

	# Loading libs
	_ = require 'lodash'

	# Config class
	Config = require './Config'

	# Users array
	users = []

	# Rooms array
	rooms = []

	# Getting configuration
	config = new Config

	# On socket connection
	io.on 'connection', (socket) ->

		# Create and add a new user created from socket
		user = new User socket
		users.push user

		# Emit back the user hash
		socket.emit 'hash', user.hash


		socket.on 'pair', (players) ->
			
			# Getting opponent socket
			opponentSocket = _.first ( _.pluck ( _.filter users, hash: players[1] ), 'socket' )
			
			# Sending first player hash to opponent
			opponentSocket.emit 'request', players[0]



		# Accepted
		socket.on 'accept', (players) ->

			# Getting players from hashes
			roomPlayers = []
			roomPlayers.push _.first ( _.filter users, hash: players[0] )
			roomPlayers.push _.first ( _.filter users, hash: players[1] )

			rooms.push players: roomPlayers, ball: x: config.window_width / 2, y: config.window_height / 2, dx: 1, dy: 0.4

			# Adding score to users (already players)
			roomPlayers[0].score = 0
			roomPlayers[1].score = 0

			# Alerting players with accepted event
			roomPlayers[1].socket.emit 'accepted', opponent_id: roomPlayers[0].hash, player_id: roomPlayers[1].hash
			roomPlayers[0].socket.emit 'accepted', opponent_id: roomPlayers[1].hash, player_id: roomPlayers[0].hash


		# Position change
		socket.on 'position-y', (data) ->

			# Finding opponent in userlist
			opponent = _.first ( _.filter users, hash: data.opponent_id )

			# Finding player in userlist
			player = _.first ( _.filter users, hash: data.player_id )

			player.position_y = data.y

			# Emit to opponent the y position
			opponent.socket.emit 'position-y', data.y


	# Making game logic
	setInterval ->
		
		rooms.forEach (room) ->

			if room.ball.y < 0 or room.ball.y > config.window_height
				room.ball.dy *= -1

			if (room.ball.x < config.pad_padding + config.pad_width and room.ball.y > room.players[0].position_y and room.ball.y < room.players[0].position_y + config.pad_height) or
				(room.ball.x > config.window_width - config.pad_padding - config.pad_width  and room.ball.y > room.players[1].position_y and room.ball.y < room.players[1].position_y + config.pad_height)
					room.ball.dx *= -1

			# Scoring
			if room.ball.x < 0
				room.players[1].score++

			if room.ball.x > config.window_width
				room.players[1].score++


			# On loose -> restart
			if room.ball.x < 0 or room.ball.x > config.window_width
				room.players[1].socket.emit 'scores', [ room.players[0].score, room.players[1].score ]
				room.players[0].socket.emit 'scores', [ room.players[1].score, room.players[0].score ]

				room.ball.x = config.window_width / 2
				room.ball.y = config.window_height / 2


			room.ball.x += room.ball.dx
			room.ball.y += room.ball.dy

			room.players[0].socket.emit 'ball-pos', x: room.ball.x, y: room.ball.y
			room.players[1].socket.emit 'ball-pos', x: 800 - room.ball.x, y: room.ball.y

	, 3