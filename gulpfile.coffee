gulp = require 'gulp'
ngClassify = require 'gulp-ng-classify'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
imagemin = require 'gulp-imagemin'
sourcemaps = require 'gulp-sourcemaps'
less = require 'gulp-less'
del = require 'del'

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
    .pipe uglify()
    .pipe concat('all.min.js')
    .pipe sourcemaps.write()
    .pipe gulp.dest('build/js')

gulp.task 'vendor', ->
  gulp.src([
    'bower_components/angular/angular.js'
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

gulp.task('default', ['vendor','scripts','less','html'])