gulp   = require('gulp-param')(require('gulp'), process.argv)
Parser = require './bmsParser.coffee'
path   = require 'path'
gm     = require 'gulp-gm'
fs     = require 'fs'
runSequence = require 'run-sequence'

paser = new Parser()

gulp.task 'concat', (p)->
  m = /^.+\//.exec p
  prefix = m[0] if m
  fs.readFile p, (err, data)->
    bms = paser.parse data.toString()
    imgs = []
    index = 0
    for k, v of bms.bmp
      while index <= k
        imgs.push path.join prefix, v
        index++
    base = imgs.shift()
    console.log imgs
    gulp.src base
      .pipe gm (gmfile)->
        gmfile.append imgs...
      .pipe gulp.dest('dest')

gulp.task 'convert', ->
  gulp.src path.join './dest', '*.bmp'
    .pipe gm (gmfile)->
      gmfile.setFormat 'jpg'
    .pipe gulp.dest('jpg')


