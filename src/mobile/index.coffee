# Application main class
class App

	# Application constructor
	constructor: ->
		@bindEvents();


	# Bind any events that are required on startup
	bindEvents: ->
		document.addEventListener 'deviceready', @onDeviceReady, false


	# deviceready Event Handler
	onDeviceReady: ->
		