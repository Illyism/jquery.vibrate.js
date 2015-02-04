module.exports = (grunt) ->

	banner ="
//     Vibrate API\n
//     Copyright (C) 2014 Ilias Ismanalijev\n
\n
//     This program is free software: you can redistribute it and/or modify\n
//     it under the terms of the GNU Affero General Public License as\n
//     published by the Free Software Foundation, either version 3 of the\n
//     License, or (at your option) any later version.\n
\n
//     This program is distributed in the hope that it will be useful,\n
//     but WITHOUT ANY WARRANTY; without even the implied warranty of\n
//     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n
//     GNU Affero General Public License for more details.\n
\n
//     You should have received a copy of the GNU Affero General Public License\n
//     along with this program.  If not, see http://www.gnu.org/licenses/\n
"

	grunt.initConfig

		coffee:
			compileWithMaps:
				options:
					sourceMap: true
				files: [
					"build/jquery/jquery.vibrate.js": 'src/coffee/jquery.vibrate.coffee'
				]

		uglify:
			compileJquery:
				options:
					mangle: false
					compress: true
					sourceMap: true
					banner: banner
					sourceMapIn: "build/jquery/jquery.vibrate.js.map"
				files: [
					"build/jquery/jquery.vibrate.min.js": "build/jquery/jquery.vibrate.js"
				]

		less:
			compile:
				options:
					compress: false
				files:
					'docs/css/style.css': 'src/less/style.less'

		jade:
			compile:
				options:
					pretty: true
				files: [
					'docs/index.html': 'src/jade/index.jade'
				]

		copy:
			docs:
				src: "build/**"
				dest: "docs/"

		jasmine:
			jquery:
				src: "build/jquery/jquery.vibrate.js"
				options:
					vendor: "http://code.jquery.com/jquery-1.11.0.min.js"
					specs: "test/vibrate.spec.js"

		watch:
			live:
				options:
					livereload: true
				files: [
					"docs/css/*"
					"docs/js/*"
					"docs/index.html"
				]
			css:
				files: ['src/less/*.less']
				tasks: ['less']
			html:
				files: ['src/jade/*.jade']
				tasks: ['jade']
			js:
				files: ['src/coffee/*.coffee']
				tasks: ['coffee', "uglify"]
			karmaJquery:
				files: ["build/jquery/jquery.vibrate.min.js", "test/test.jquery.js"]
				tasks: ["jasmine:jquery"]

	# Docs
	grunt.loadNpmTasks 'grunt-contrib-less'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	
	# Javascript
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-uglify'

	# Development
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-jasmine'


	grunt.registerTask 'default', [
		'less'
		"coffee"
		"uglify"
		"jade"
	]

	grunt.registerTask 'test', [
		"coffee"
		"uglify"
		"jasmine"
	]

	grunt.registerTask 'docs', [
		"less"
		"coffee"
		"copy"
		"jade"
	]

	grunt.registerTask 'live', [
		"coffee"
		"uglify"
		'less'
		"jade"
		"watch"
	]