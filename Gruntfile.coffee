module.exports = (grunt) =>
	grunt.initConfig
		coffee:
			bin:
				options:
					bare: true
				files:
					"lib/musicplayer.js": "src/cli.coffee"

	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.registerTask "default", ["coffee"]
