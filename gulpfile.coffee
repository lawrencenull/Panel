gulp = require 'gulp'
ngClassify = require 'gulp-ng-classify'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
imagemin = require 'gulp-imagemin'
sourcemaps = require 'gulp-sourcemaps'
less = require 'gulp-less'
watch = require 'gulp-watch'
del = require 'del'
tinylr = require('tiny-lr')()

#paths =
#  scripts: ['dist/coffee/**/*.coffee'],
#  images: 'src/img/**/*'




#gulp.task 'clean', (cb)->
#  del(['build'], cb)

#gulp.task 'classify', ->
#  gulp.src 'src/**/*.coffee'
#    .pipe ngClassify()
#    .pipe gulp.dest 'dist'




gulp.task 'scripts', ->
  gulp.src('src/**/*.coffee')
    .pipe ngClassify()
#    .pipe gulp.dest 'dist'
    .pipe sourcemaps.init()
    .pipe coffee()
#    .pipe uglify()
    .pipe concat('all.min.js')
    .pipe sourcemaps.write()
    .pipe gulp.dest('build/js')

gulp.task 'vendor', ->
  gulp.src([
    'bower_components/jquery/dist/jquery.js'
    'bower_components/jquery-ui/jquery-ui.min.js'
    'bower_components/perfect-scrollbar/min/perfect-scrollbar.min.js'
    'bower_components/chartist/libdist/chartist.js'
    'bower_components/angular/angular.js'
    'bower_components/angular-route/angular-route.js'
    'bower_components/angular-animate/angular-animate.js'
    'bower_components/angular-sanitize/angular-sanitize.js'
    'bower_components/videogular/videogular.js'
    'bower_components/videogular-controls/controls.js'
    'bower_components/videogular-overlay-play/overlay-play.js'
    'bower_components/jquery-ui-touch-punch/jquery.ui.touch-punch.js'
#    'bower_components/videogular-poster/poster.js'
  ])
    .pipe concat('vendor.min.js')
    .pipe gulp.dest('build/js')

gulp.task 'css', ->
  gulp.src([
#    'bower_components/bootstrap/less/bootstrap.less',
#    'src/**/*.less'
    'bower_components/chartist/libdist/chartist.min.css'
    'src/**/*.css'
  ])
#  .pipe(less())
  .pipe concat('all.css')
  .pipe(gulp.dest('./build/css'));

gulp.task 'fonts', ->
  gulp.src('src/css/fonts/**/*.*')
    .pipe(gulp.dest('build/css/fonts'));

gulp.task 'html', ->
  gulp.src('src/**/*html')
    .pipe(gulp.dest('build'));

gulp.task 'video', ->
  gulp.src('src/video/**/*.*')
    .pipe(gulp.dest('build/video'));

gulp.task 'img', ->
  gulp.src('src/img/**/*.*')
    .pipe(gulp.dest('build/img'));
gulp.task 'images', ->
  gulp.src('src/images/**/*.*')
    .pipe(gulp.dest('build/images'));

gulp.task 'express', ->
  express = require 'express'
  app = express()
  app.use(require('connect-livereload')(port: 4002))
  app.use(express.static(__dirname+'/build'))
  app.listen 4000

gulp.task 'watch',->
  gulp.watch('src/**/*.coffee', ['scripts']);
  gulp.watch('bower_components/perfect-scrollbar/**/*.js', ['vendor']);
  gulp.watch('src/**/*.css', ['css']);
  gulp.watch('src/**/*html', ['html']);
  gulp.watch('src/img/**/*.*', ['img']);
  gulp.watch('build/**/*.*', (event) ->
    fileName = require('path').relative(__dirname, event.path)
    tinylr.changed
      body:
        files: [fileName]
  )

gulp.task 'livereload', ->
  tinylr.listen 4002

gulp.task('default', ['vendor','scripts','css','fonts','video','html','img','images','express','livereload','watch'])