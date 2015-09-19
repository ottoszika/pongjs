# Class defining a client
class @Client

	# Initialize socket and connectivity
	constructor: ->

		# Connecting to server
		@socket = io.connect window.location.origin

		# Store self as this
		self = @

		# Socket connection event (hash event)
		@socket.on 'hash', (hash) ->

			# Set hash input
			$('#hash').text hash
			
			# Store hash and socket (socket from the parent fn)
			@socket = self.socket
			@hash = hash

			# Assign this to self variable for further usage of `this` current state
			self = @

			# On click event for connect button
			$('#connect').click ->

				# Getting essential details like opponent id, my id, socket handler
				opponent = $('#opponent').val()
				me = self.hash
				socket = self.socket

				# Emitting a pair event with my id and opponent id
				socket.emit 'pair', [ me, opponent ]


		# On opponent request
		@socket.on 'request', (hash) ->
			$('#opponent-hash').text(hash);

			$('#request').show()


		# Accept connection
		$('#accept').click ->

			# Getting important data
			me = $('#hash').text()
			opponent = $('#opponent-hash').text()

			socket = self.socket

			socket.emit 'accept', [ me, opponent ]


		# On accepted event
		@socket.on 'accepted', (room) ->
				# Creating a game instance
				game = new Game self.socket, room.player_id, room.opponent_id

				# Creating Phaser game
				window.game = new Phaser.Game 800, 600, Phaser.AUTO, 'game', game

new Client