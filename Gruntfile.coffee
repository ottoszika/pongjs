module.exports = (grunt) ->

	grunt.initConfig

		# Packages file
		pkg: grunt.file.readJSON("package.json")


		# Clean command
		# This will clean each directory from the list below
		clean: ['app', 'build', 'public', 'bower_components', 'logs']


		# Install bower packages
		bower:
			dist:
				options:
					targetDir: 'public/bower'
					install: true
					verbose: true
					cleanup: true
					layout: 'byType'


		# Compile CoffeeScript files
		# Client and server
		coffee:
			dist:
				files: [
					expand: true
					cwd: 'src/server'
					src: ['{,*/}*.coffee']
					dest: 'app/'
					rename: (dest, src) ->
						dest + '/' + src.replace /\.coffee$/, '.js'

				,

					expand: true
					cwd: 'src/client'
					src: ['{,*/}*.coffee']
					dest: 'build/'
					rename: (dest, src) ->
						dest + '/' + src.replace /\.coffee$/, '.js'

				,

					expand: true
					cwd: 'src/common'
					src: ['{,*/}*.coffee']
					dest: 'app/'
					rename: (dest, src) ->
						dest + '/' + src.replace /\.coffee$/, '.js'

				,

					expand: true
					cwd: 'src/common'
					src: ['{,*/}*.coffee']
					dest: 'build/'
					rename: (dest, src) ->
						dest + '/' + src.replace /\.coffee$/, '.js'
				]


		# Compile less files
		less:
			dist:
				files: [
					expand: true
					cwd: 'src/less'
					src: '*.less'
					dest: 'build/'
					ext: '.css'
				]


		# Concat Javascript and CSS files
		# Added banner with package name, version and date
		concat:
			options:
				stripBanners: true
				banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
						'<%= grunt.template.today("yyyy-mm-dd") %> */\n'

			dist:
				files: [
					src: ['build/**/*.js', 'public/bower/**/*.js']
					dest: 'public/js/app.js'

				,

					src: ['build/**/*.css', 'public/bower/**/*.css']
					dest: 'public/css/styles.css'
				]


		# Minify Javascript file (only in production)
		uglify:
			dist:
				options:
					sourceMap: true
					sourceMapIncludeSources: true

				files:
					'public/js/app.min.js': ['public/js/app.js']


		# Minify CSS file (only in production)
		cssmin:
			dist:
				files:
					'public/css/styles.min.css': ['public/css/styles.css']


		# Compile Jade templates
		jade:
			dist:
				files: [
					cwd: 'src/views'
					src: '**/*.jade'
					dest: 'public'
					expand: true
					ext: '.html'
				]


		# Copy built files to public (for debug)
		copy:
			dev:
				files: [
					expand: true
					cwd: 'build/'
					src: '**/*.js'
					dest: 'public/js'

				,

					expand: true
					cwd: 'build/'
					src: '**/*.css'
					dest: 'public/css'

				,

					expand: true
					cwd: 'src/resources/'
					src: '**/*.*'
					dest: 'public/resources'
				]

			dist:
				files: [
					expand: true
					cwd: 'src/resources/'
					src: '**/*'
					dest: 'public/resources'
				]


		# Inject styles and scripts to index.html
		injector:
			dev:
				options:
					min: false
					ignorePath: 'public'
					expand: true
				files:
					'public/index.html': ['public/bower/*/*.js', 'public/js/*.js', 'public/bower/*/*.css', 'public/css/*.css']

			dist:
				options:
					min: true
					ignorePath: 'public'
					expand: true

				files:
					'public/index.html': ['public/js/*/*.min.js', 'public/css/*/*.min.css']


	# Load some NPM Tasks
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-less'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-injector'
	grunt.loadNpmTasks 'grunt-bower-task'


	# Register tasks for debug (default) and production (dist)
	grunt.registerTask 'default', ['clean', 'bower', 'coffee', 'less', 'jade', 'copy', 'injector:dev']
	grunt.registerTask 'dist', ['clean', 'bower', 'coffee', 'less', 'concat', 'uglify', 'cssmin', 'jade', 'injector:dist']
	grunt.registerTask 'dev', ['coffee', 'less', 'jade', 'copy', 'injector:dev']