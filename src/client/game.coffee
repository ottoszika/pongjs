class @Game

	# Init socket and opponent
	constructor: (@socket, @player_id, @opponent_id, @pad_width, @pad_height, @pad_padding, @ball_diameter) ->
		@speed = 5

	# Preloading resources
	preload: ->
		game.load.image 'pad', 'resources/pad.png'
		game.load.image 'ball', 'resources/ball.png'


	# Create game objects
	create: ->
		@me = game.add.image @pad_padding, game.height / 2 - @pad_height / 2, 'pad'
		@opponent = game.add.image game.width - @pad_padding - @pad_width, game.height / 2 - @pad_height / 2, 'pad'
		@ball = game.add.image game.width / 2, game.height / 2, 'ball'

		@me.width = @pad_width
		@me.height = @pad_height

		@opponent.width = @pad_width
		@opponent.height = @pad_height

		@ball.width = @ball_diameter
		@ball.height = @ball_diameter

		#Creating self from current this
		self = @

		# Adding events
		@socket.on 'position-y', (y) ->
			self.opponent.y = y


		@socket.on 'ball-pos', (ball) ->
			self.ball.x = ball.x
			self.ball.y = ball.y

		@socket.on 'scores', (scores) ->
			$('#score').text(scores[0] + ' - ' + scores[1])


	# Do every time
	update: ->

		# Up movement
		if game.input.keyboard.isDown Phaser.Keyboard.UP
			return if @me.y < 0

			@me.y -= @speed
			@socket.emit 'position-y', y: @me.y, player_id: @player_id, opponent_id: @opponent_id


		# Down movement
		if game.input.keyboard.isDown Phaser.Keyboard.DOWN
			return if @me.y > game.height - @pad_height

			@me.y += @speed
			@socket.emit 'position-y', y: @me.y, player_id: @player_id, opponent_id: @opponent_id