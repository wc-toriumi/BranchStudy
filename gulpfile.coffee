gulp = require 'gulp'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
rename = require 'gulp-rename'
plumber = require 'gulp-plumber'
sourcemaps = require 'gulp-sourcemaps'
del = require 'del'
changed = require 'gulp-changed'
sass = require 'gulp-sass'
minifycss = require 'gulp-minify-css'
haml = require 'gulp-haml'
prettify = require 'gulp-prettify'
config = require './gulp_config.json'

gulp.task 'compile', ->
	return gulp.src config.buildPath.coffee
	.pipe plumber()
	.pipe changed config.buildPath.dest, { extension: '.js'}
	.pipe coffee()
	.pipe gulp.dest config.buildPath.dest

gulp.task 'compile_sp', ->
	return gulp.src config.buildPathSP.coffee
	.pipe plumber()
	.pipe changed config.buildPathSP.dest, { extension: '.js'}
	.pipe coffee()
	.pipe gulp.dest config.buildPathSP.dest

gulp.task 'compile-map', ->
	return gulp.src config.buildPath.coffee
	.pipe plumber()
	.pipe changed config.buildPath.dest, { extension: '.js'}
	.pipe sourcemaps.init()
	.pipe coffee()
	.pipe sourcemaps.write '.',
		addComment: true
		sourceRoot: '/coffee'
	.pipe gulp.dest config.buildPath.dest

gulp.task 'coffee-compile-mini', ->
	return gulp.src paths.coffee
	.pipe plumber()
	.pipe sourcemaps.init
		loadMaps: true
	.pipe coffee()
	.pipe rename {suffix: '.min'}
	.pipe uglify()
	.pipe gulp.dest paths.dest
	.pipe sourcemaps.write '.',
		addComment: true
		sourceRoot: '/coffee'
	.pipe gulp.dest paths.dest

#compileのタスク
gulp.task 'sass', ->
	for i in [0 ... config.buildPathScss.scss.length]
		gulp.src config.buildPathScss.scss[i]
		.pipe plumber()
		.pipe sass()
		.pipe minifycss()
		.pipe gulp.dest config.buildPathScss.dest[i]
	return

#haml コンパイルタスク
gulp.task 'haml', ->
	return gulp.src config.buildPathHaml.haml
	.pipe haml()
	.pipe prettify()
	.pipe gulp.dest config.buildPathHaml.dest

#haml コンパイルタスク本番
gulp.task 'haml_prod', ->
	return gulp.src config.buildPathHaml.haml
	.pipe haml()
	.pipe gulp.dest config.buildPathHaml.dest

gulp.task 'watch', ->
	gulp.watch ['**/coffee/**/*.coffee'], ['compile']
	gulp.watch [config.buildPathScss.scss], ['sass']
	gulp.watch [config.buildPathHaml.haml],['haml']

gulp.task 'watch_sp', ->
	gulp.watch ['m/smt/coffee/**/*.coffee'], ['compile_sp']

gulp.task 'clean', (cb)->
	del('./js/*', cb)

gulp.task 'default', ['clean', 'compile', 'coffee-compile-mini']

