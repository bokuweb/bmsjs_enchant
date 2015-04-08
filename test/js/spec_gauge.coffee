expect = chai.expect
Sys = require '../../app/gamesys'
Gauge = require '../../app/gauge'
utils = require './utils'

INIT_RATE = 20
TEST_TOTAL = 80
TEST_NOTE_NUM = 30

describe 'gauge class test', ()->
  capNum = 0
  rate = INIT_RATE
  sys = new Sys 640, 480
  gauge = new Gauge sys
  res =
    gaugeImage : 
      type : "image"
      src : "../res/gauge.png"
      width : 4
      height : 12
      x : 0
      y : 150
      z : 1

    rateLabel : 
      type : "label"
      align : "left"
      font : "12px Arial"
      color : "rgba(0, 0, 0, 0.8)"
      x : 0
      y : 100
      z : 1

  config =
    initRate : INIT_RATE
    greatIncVal : TEST_TOTAL / TEST_NOTE_NUM
    goodIncVal : TEST_TOTAL / TEST_NOTE_NUM * 0.5
    badDecVal : 1.8
    poorDecVal : 4.6
    num : 50
    clearVal : 40

  it 'initialize gauge and capture gauge', (done)->
    gauge.init res, config
    gauge.start 30
    expect(gauge.get()).to.be.equal 20
    # wait frame updated
    setTimeout ->
      utils.capture "capture/gauge/gauge" + capNum++
      done()
    , 50

  it 'should gauge is 100%(20%+80%) when all pgreat', (done)->
    for i in [0...TEST_NOTE_NUM]
      gauge.update 'pgreat'
      expect(gauge.get()).to.be.equal ~~((config.initRate + config.greatIncVal * (i + 1)).toFixed())
    # wait frame updated
    setTimeout ->
      utils.capture "capture/gauge/gauge" + capNum++
      done()
    , 50

  it 'should gauge is 100%(20%+80%) when all great', (done)->
    for i in [0...TEST_NOTE_NUM]
      gauge.update 'pgreat'
      expect(gauge.get()).to.be.equal ~~((config.initRate + config.greatIncVal * (i + 1)).toFixed())
    # wait frame updated
    setTimeout ->
      utils.capture "capture/gauge/gauge" + capNum++
      done()
    , 50

  it 'should gauge is 60%(20%+40%) when all good', (done)->
    for i in [0...TEST_NOTE_NUM]
      gauge.update 'good'
      expect(gauge.get()).to.be.equal ~~((config.initRate + config.goodIncVal * (i + 1)).toFixed())
    # wait frame updated
    setTimeout ->
      utils.capture "capture/gauge/gauge" + capNum++
      done()
    , 50

  it 'should gauge is 2% when all bad', (done)->
    for i in [0...TEST_NOTE_NUM]
      gauge.update 'bad'
      rate = ~~((config.initRate - config.badDecVal * (i + 1)).toFixed())
      expect(gauge.get()).to.be.equal if rate < 2 then 2 else rate
    # wait frame updated
    setTimeout ->
      utils.capture "capture/gauge/gauge" + capNum++
      done()
    , 50

  it 'should gauge is 2% when all poor', (done)->
    for i in [0...TEST_NOTE_NUM]
      gauge.update 'poor'
      rate = ~~((config.initRate - config.poorDecVal * (i + 1)).toFixed())
      expect(gauge.get()).to.be.equal if rate < 2 then 2 else rate
    # wait frame updated
    setTimeout ->
      utils.capture "capture/gauge/gauge" + capNum++
      done()
    , 50

  before (done)->
    sys.preload [res.gaugeImage.src]
    sys.start().then -> done()

  after ()->
    gauge.remove()

  beforeEach ()->

  afterEach ()->
    gauge.clear()
