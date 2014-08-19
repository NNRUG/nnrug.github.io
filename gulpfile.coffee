gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
uglify  = require 'gulp-uglify'
plumber = require 'gulp-plumber'
notify  = require 'gulp-notify'
slim    = require 'gulp-slim'
serve   = require "gulp-serve"

sass    = require 'gulp-ruby-sass'
csso    = require 'gulp-csso'
prefix  = require 'gulp-autoprefixer'
clean   = require 'gulp-clean'
rev     = require 'gulp-rev'
revCollect = require 'gulp-rev-collector'


paths =
  assets:
    scripts:    ['src/scripts/*.coffee']
    styles:     ['src/styles/*.sass', 'src/styles/*.scss']
    rev:        ['./assets/app.css']
    dest:       './assets'
    revCollect:    ['./assets/*.json', './*.html']
  templates:
    src:  ['src/templates/*.slim']
    dest: './'

plumberCfg = errorHandler: (error) ->
  console.log error
  notify.onError("Error: <%= error.message %>").apply @, arguments

gulp.task 'styles', () ->
  gulp.src paths.assets.styles
  .pipe plumber plumberCfg
  .pipe sass()
  .pipe prefix 'last 2 version'
  .pipe csso()
  .pipe gulp.dest paths.assets.dest

gulp.task 'templates', ->
  gulp.src paths.templates.src
  .pipe slim pretty: true
  .pipe gulp.dest paths.templates.dest

gulp.task 'clean-assets', ->
  gulp.src "#{paths.assets.dest}/app-*"
  .pipe clean()

gulp.task 'rev', ->
  gulp.src paths.assets.rev
  .pipe rev()
  .pipe gulp.dest paths.assets.dest
  .pipe rev.manifest()
  .pipe gulp.dest paths.assets.dest

gulp.task 'rev-collect', ->
  gulp.src paths.assets.revCollect
  .pipe revCollect(replaceReved: true)
  .pipe gulp.dest paths.templates.dest

gulp.task 'watch', ->
  gulp.watch paths.templates.src, ['templates']
  gulp.watch paths.assets.styles, ['styles']
  gulp.watch paths.assets.rev, ['clean-assets', 'rev']
  gulp.watch paths.assets.revCollect, ['rev-collect']

gulp.task 'serve', serve
  root: __dirname

gulp.task 'compile', ['templates', 'styles', 'clean-assets', 'rev', 'rev-collect']

gulp.task 'default', ['compile', 'watch', 'serve']
