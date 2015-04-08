expect = chai.expect
Timer = require '../../app/timer'

describe 'timer class test', ->
  timer = null
  it 'should timer.get() return 0 before start', ->
    time = timer.get()
    expect time
      .to.be.equal 0

  it 'set timer 1000msec, should get() return about 1000msec', (done)->
    timer.start()
    setTimeout ->
      time = timer.get()
      expect time
        .to.be.within 950, 1050
      done()
    , 1000

  it 'should clear timer', ()->
    timer.clear()
    expect timer.get()
      .to.be.equal 0

  before ->
    timer = new Timer()

  after ->

  beforeEach ->

  afterEach ->
