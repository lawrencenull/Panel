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
    'bower_components/angular/angular.js'
    'bower_components/angular-route/angular-route.js'
  ])
    .pipe concat('vendor.min.js')
    .pipe gulp.dest('build/js')

gulp.task 'less', ->
  gulp.src([
    'bower_components/bootstrap/less/bootstrap.less',
    'src/**/*.less'
  ])
  .pipe(less())
  .pipe concat('all.css')
  .pipe(gulp.dest('./build/css'));

gulp.task 'html', ->
  gulp.src('src/**/*html')
    .pipe(gulp.dest('build'));

gulp.task 'express', ->
  express = require 'express'
  app = express()
  app.use(require('connect-livereload')(port: 4002))
  app.use(express.static(__dirname+'/build'))
  app.listen 4000

gulp.task 'watch',->
  gulp.watch('src/**/*.coffee', ['scripts']);
  gulp.watch('src/**/*.less', ['less']);
  gulp.watch('src/**/*html', ['html']);
  gulp.watch('build/**/*.*', (event) ->
    fileName = require('path').relative(__dirname, event.path)
    tinylr.changed
      body:
        files: [fileName]
  )

gulp.task 'livereload', ->
  tinylr.listen 4002

gulp.task('default', ['vendor','scripts','less','html', 'express','livereload','watch'])