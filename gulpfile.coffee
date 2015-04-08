gulp = require 'gulp'
source = require 'vinyl-source-stream'
browserify = require 'browserify'
connect = require 'gulp-connect'
jsmin = require 'gulp-jsmin'
rename = require 'gulp-rename'
mochaPhantomJS = require 'gulp-mocha-phantomjs'
cson = require 'gulp-cson'
coffeelint = require 'gulp-coffeelint'

gulp.task 'lint', ->
  gulp.src './app/*.coffee'
    .pipe coffeelint()
    .pipe coffeelint.reporter()

gulp.task 'appBuild', ['lint'],  ->
  browserify
      entries : ['./app/test.coffee']
      extensions: ['.coffee', '.js']
    .transform 'coffeeify'
    .bundle()
    .pipe source 'bundle.js'
    .pipe gulp.dest 'build'

  gulp.src './res/*.cson'
    .pipe cson()
    .pipe gulp.dest './res'    

gulp.task 'testBuild' , ->
  browserify
      entries : ['./test/js/spec_entry.coffee']
      extensions: ['.coffee', '.js']
    .transform 'coffeeify'
    .bundle()
    .pipe source 'test_all.js'
    .pipe gulp.dest 'test'

  gulp.src './test/js/*.cson'
    .pipe cson()
    .pipe gulp.dest './test/js/'    

gulp.task 'cson', ->
  gulp.src './res/*.cson'
    .pipe cson()
    .pipe gulp.dest './res'

  gulp.src './test/js/*.cson'
    .pipe cson()
    .pipe gulp.dest './test/js/'    

gulp.task 'build', ['cson', 'appBuild', 'testBuild']

gulp.task 'jsmin', ['build'],  ->
  gulp.src './build/bundle.js'
  .pipe jsmin()
  .pipe rename {suffix: '.min'}
  .pipe gulp.dest './build/'

gulp.task 'connect', ->
  connect.server
    root: './'

gulp.task 'test', ['testBuild'], ()->
  gulp
    .src './test/runner.html'
    .pipe mochaPhantomJS
      #reporter: './node_modules/gulp-mocha-phantomjs/node_modules/mocha-phantomjs/node_modules/mocha/lib/reporters/nyan.js'
      phantomjs: 
        viewportSize: 
          width: 800
          height: 600
        dump:'test.xml'

gulp.task 'default', ['build', 'jsmin', 'connect']




