expect = chai.expect
Sys = require '../../app/gamesys'
Stats = require '../../app/stats'
utils = require './utils'

MAX_SCORE = 200000
TEST_NOTE_NUM = 30

describe 'stats class test', ()->
  capNum = 0
  sys = new Sys 640, 480
  stats = new Stats sys
  res =
    scoreLabel :
      type  : "label"
      align : "left"
      font  : "12px Arial"
      color : "rgba(0, 0, 0, 0.8)"
      x     : 0
      y     : 100
      z     : 1

  it 'initialize stats and capture stats', (done)->
    utils.capture "capture/stats/stats" + capNum++
    expect(stats.get().score).to.be.equal 0
    expect(stats.get().combo).to.be.equal 0
    expect(stats.get().pgreat).to.be.equal 0
    expect(stats.get().great).to.be.equal 0
    expect(stats.get().good).to.be.equal 0
    expect(stats.get().bad).to.be.equal 0
    expect(stats.get().poor).to.be.equal 0
    done()

  it 'score is MAX_SCORE when all pgreat', (done)->
    stats.update 'pgreat' for i in [0...TEST_NOTE_NUM]
    expect(stats.get().score).to.be.equal MAX_SCORE
    expect(stats.get().combo).to.be.equal TEST_NOTE_NUM
    expect(stats.get().pgreat).to.be.equal TEST_NOTE_NUM
    expect(stats.get().great).to.be.equal 0
    expect(stats.get().good).to.be.equal 0
    expect(stats.get().bad).to.be.equal 0
    expect(stats.get().poor).to.be.equal 0
    # wait frame update
    setTimeout ->
      utils.capture "capture/stats/stats" + capNum++
      done()
    , 50

  it 'score is MAX_SCORE * 0.7 when all great', (done)->
    stats.update 'great' for i in [0...TEST_NOTE_NUM]
    expect(stats.get().score).to.be.equal MAX_SCORE * 0.7
    expect(stats.get().combo).to.be.equal TEST_NOTE_NUM
    expect(stats.get().pgreat).to.be.equal 0
    expect(stats.get().great).to.be.equal TEST_NOTE_NUM
    expect(stats.get().good).to.be.equal 0
    expect(stats.get().bad).to.be.equal 0
    expect(stats.get().poor).to.be.equal 0
    # wait frame update
    setTimeout ->
      utils.capture "capture/stats/stats" + capNum++
      done()
    , 50

  it 'score is MAX_SCORE * 0.5 when all good', (done)->
    stats.update 'good' for i in [0...TEST_NOTE_NUM]
    expect(stats.get().score).to.be.equal MAX_SCORE * 0.5
    expect(stats.get().combo).to.be.equal TEST_NOTE_NUM
    expect(stats.get().pgreat).to.be.equal 0
    expect(stats.get().great).to.be.equal 0
    expect(stats.get().good).to.be.equal TEST_NOTE_NUM
    expect(stats.get().bad).to.be.equal 0
    expect(stats.get().poor).to.be.equal 0
    # wait frame update
    setTimeout ->
      utils.capture "capture/stats/stats" + capNum++
      done()
    , 50

  it 'score is 0 when all bad', (done)->
    stats.update 'bad' for i in [0...TEST_NOTE_NUM]
    expect(stats.get().score).to.be.equal 0
    expect(stats.get().combo).to.be.equal 0
    expect(stats.get().pgreat).to.be.equal 0
    expect(stats.get().great).to.be.equal 0
    expect(stats.get().good).to.be.equal 0
    expect(stats.get().bad).to.be.equal TEST_NOTE_NUM
    expect(stats.get().poor).to.be.equal 0
    # wait frame update
    setTimeout ->
      utils.capture "capture/stats/stats" + capNum++
      done()
    , 50

  it 'score is 0 when all poor', (done)->
    stats.update 'poor' for i in [0...TEST_NOTE_NUM]
    expect(stats.get().score).to.be.equal 0
    expect(stats.get().combo).to.be.equal 0
    expect(stats.get().pgreat).to.be.equal 0
    expect(stats.get().great).to.be.equal 0
    expect(stats.get().good).to.be.equal 0
    expect(stats.get().bad).to.be.equal 0
    expect(stats.get().poor).to.be.equal TEST_NOTE_NUM
    # wait frame update
    setTimeout ->
      utils.capture "capture/stats/stats" + capNum++
      done()
    , 50

  it 'all judge num is 6', (done)->
    for i in [0...TEST_NOTE_NUM / 5]
      stats.update 'pgreat'
      stats.update 'great'
      stats.update 'good'
      stats.update 'bad'
      stats.update 'poor'
    expect(stats.get().score).to.be.equal ~~((MAX_SCORE / TEST_NOTE_NUM * 13.2).toFixed())
    expect(stats.get().combo).to.be.equal 3
    expect(stats.get().pgreat).to.be.equal 6
    expect(stats.get().great).to.be.equal 6
    expect(stats.get().good).to.be.equal 6
    expect(stats.get().bad).to.be.equal 6
    expect(stats.get().poor).to.be.equal 6
    # wait frame update
    setTimeout ->
      utils.capture "capture/stats/stats" + capNum++
      done()
    , 50
    
  before (done)->
    stats.init res, TEST_NOTE_NUM, MAX_SCORE
    sys.start().then -> done()
      
  after ()->
    stats.remove()
    
  beforeEach ()->

  afterEach ()->
    stats.clear()
