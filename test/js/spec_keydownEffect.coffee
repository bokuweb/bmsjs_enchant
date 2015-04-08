expect = chai.expect
KeydownEffect = require '../../app/keydownEffect'
Sys = require '../../app/gamesys'
utils = require './utils'
$ = require 'jquery'

describe 'KeydownEffect class test', ()->
  @timeout 10000  
  capNum = 0
  sys = new Sys 640, 480
  effect = new KeydownEffect sys

  x = [41,63,80,102,119,141,158,0]
  res =
    y : 0
    z : 1
    turntableKeydownImage : 
      type : "image"
      src : "../res/turntable-keydown.png"
      width : 41
      height : 316
    whiteKeydownImage : 
      type : "image"
      src : "../res/white-keydown.png"
      width : 22
      height : 316
    blackKeydownImage : 
      type : "image"
      src : "../res/black-keydown.png"
      width : 17
      height : 316

  it 'keydown effect show test, check runner.html or capture directory',(done)->
    promise = null
    index = 0
    effect.init res, x
    promise = do ->
      d = new $.Deferred
      id = setInterval ->
        effect.show index++
        utils.capture "capture/keydownEffect/keydownEffect" + capNum++
        if x.length is index
          clearInterval id
          d.resolve() 
      , 20
      d.promise()
    promise.then -> done()

  before (done)->
    sys.preload [res.whiteKeydownImage.src, res.blackKeydownImage.src, res.turntableKeydownImage.src]
    sys.start().then -> done()

  after ->

  beforeEach ->

  afterEach ->

