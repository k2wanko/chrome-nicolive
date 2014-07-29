
gulp = require 'gulp'
gutil = require 'gulp-util'

yml = require 'gulp-yml'

include = require 'gulp-include'
coffee = require 'gulp-coffee'
sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'

jade = require 'gulp-jade'

stylus = require 'gulp-stylus'

zip = require 'gulp-zip'

bower = require 'gulp-bower'

clean = require 'gulp-clean'

DEBUG = if process.env.NODE_ENV is 'production' then false else true

gulp.task 'default', ['manifest', 'locales', 'bower', 'js', 'html', 'css']

gulp.task 'clean', ->
  gulp.src ['app/**/*.json', 'app/*.js', 'app/*.css', 'app/*.html']
  .pipe clean force: true

gulp.task 'watch', ['default'], ->
  gulp.watch 'src/manifest.yml', ['manifest']
  gulp.watch 'src/_locales/**/*.yml', ['locales']
  gulp.watch 'src/**/*.coffee', ['js']
  gulp.watch 'src/*.jade', ['html']
  gulp.watch 'src/*.styl', ['css']

gulp.task 'manifest', ->
  gulp.src 'src/manifest.yml'
  .pipe yml().on( 'manifest:error', gutil.log )
  .pipe gulp.dest 'app/'

gulp.task 'bower', ->
  bower()

gulp.task 'locales', ->
  gulp.src 'src/_locales/**/*.yml'
  .pipe yml().on( 'manifest:error', gutil.log )
  .pipe gulp.dest 'app/_locales/'

gulp.task 'js', ->

  options =
    compress:
      global_defs:
        DEBUG: DEBUG
      
  gulp.src 'src/*.coffee'
  .pipe include()
  .pipe coffee().on( 'coffee:error', gutil.log )
  .pipe sourcemaps.init()
  .pipe uglify options
  .pipe sourcemaps.write( './maps' )
  .pipe gulp.dest 'app/'
    
gulp.task 'html', ->
  gulp.src 'src/*.jade'
  .pipe jade()
  .pipe gulp.dest 'app/'
    
gulp.task 'css', ->
  gulp.src 'src/*.styl'
  .pipe stylus()
  .pipe gulp.dest 'app/'

gulp.task 'package', ['default'], ->
  gulp.src 'app/*'
  .pipe zip 'package.zip'
  .pipe gulp.dest './'

gulp.task 'publish', ->
  return console.error "Error: Isn't production mode." if DEBUG
