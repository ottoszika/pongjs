module.exports = (io) ->

	# Include User model
	User = require './user'

	# Loading libs
	_ = require 'lodash'

	# Users array
	users = []

	# Rooms array
	rooms = []

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

			rooms.push players: roomPlayers, ball: x: 400, y: 300

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