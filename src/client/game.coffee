class @Game

	# Init socket and opponent
	constructor: (@socket, @player_id, @opponent_id) ->

	# Preloading resources
	preload: ->
		game.load.image 'pad', 'resources/pad.png'


	# Create game objects
	create: ->
		@me = game.add.image 10, 300, 'pad'
		@opponent = game.add.image 770, 300, 'pad'

		# Creating self from current this
		self = @

		# Adding events
		@socket.on 'position-y', (y) ->
			self.opponent.y = y


	# Do every time
	update: ->

		# Up movement
		if game.input.keyboard.isDown Phaser.Keyboard.UP
			@me.y--
			@socket.emit 'position-y', y: @me.y, player_id: @player_id, opponent_id: @opponent_id


		# Down movement
		if game.input.keyboard.isDown Phaser.Keyboard.DOWN
			@me.y++
			@socket.emit 'position-y', y: @me.y, player_id: @player_id, opponent_id: @opponent_id