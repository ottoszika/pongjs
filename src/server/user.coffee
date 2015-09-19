# User model
class User

	# Initialize with socket handler and generate a new hash
	constructor: (@socket) ->
		randomstring = require 'randomstring'

		@hash = randomstring.generate 8


module.exports = User