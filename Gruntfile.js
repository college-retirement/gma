module.exports = function (Grunt) {
	"use strict";


	Grunt.initConfig({
		"sass": {
			"dev": {
				'files': {
					'public/assets/css/app.css': 'app/assets/sass/app.sass'
				}
			},
			"dist": {
				'files': {
					'public/assets/css/app.css': 'app/assets/sass/app.sass'
				},
				'options': {
					'style': 'compressed'
				}

			}
		},
		"ngmin": {
			"controllers": {
				"src": ['app/assets/js/main.js', 'app/assets/js/**/*.js'],
				"dest": 'app/assets/js/components.js'
			},
		},
		"uglify": {
			"dev": {
				"files": {
					'public/assets/js/application.min.js': [
						'app/assets/js/components.js'
					]
				}
			},
			"dist": {
				"files": {
					'public/assets/js/application.min.js': [
						'app/assets/js/components.js'
					]
				},
				"options": {
					'compress': true,
					'mangle': true
				}
			}
		},
		"clean": {
			"dev": {
				src: ['app/assets/js/components.js'],
				options: {
					force: true
				}
			}
		},
		"watch": {
			'sass': {
				'files': ['**/*.sass', '**/*.scss'],
				'tasks': ['sass'],
			},
			'css': {
				'files': 'public/assets/**/*.css',
				'options': {
					'livereload': true
				}
			},
			'js': {
				'files': ['app/assets/js/**/*.js', '!app/assets/js/components.js'],
				'tasks': ['clean', 'ngmin', 'uglify']
			},
			'jsBuild': {
				'files': 'public/assets/application.js',
				'options': {
					'livereload': true
				}
			},
			'views': {
				'files': ['public/assets/views/**/*.html'],
				'options': {
					'livereload': true
				}
			},
			// 'test': {
			// 	'files': 'app/tests/*.php',
			// 	'tasks': ['phpunit']
			// }
		}
	});

	Grunt.loadNpmTasks('grunt-contrib-watch');
	Grunt.loadNpmTasks('grunt-contrib-sass');
	Grunt.loadNpmTasks('grunt-ngmin');
	Grunt.loadNpmTasks('grunt-contrib-uglify');
	Grunt.loadNpmTasks('grunt-contrib-concat');
	Grunt.loadNpmTasks('grunt-contrib-clean');
	Grunt.loadNpmTasks('grunt-notify');

	Grunt.registerTask('dist', ['sass:dist', 'ngmin', 'uglify:dist']);
};
