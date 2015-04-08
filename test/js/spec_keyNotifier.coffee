expect = chai.expect
KeyNotifier = require '../../app/keyNotifier'
Timer = require '../../app/timer'
utils = require './utils'
$ = require 'jquery'

describe 'keyNotifier class test', ()->
  timer = new Timer()
  key = new KeyNotifier timer
  testId = 0
  eventId = 0

  keyConfig = [
    'Z'
    'S'
    'X'
    'D'
    'C'
    'F'
    'V'
    16
  ]

  it 'should call listener and passed keydown time when generate keydown by 100msec', (done)->
    timerId =  null
    listener = (name, time, id)->
      console.log "press key = #{name} id = #{id} key down time = #{time}"
      expect(id).to.be.equal testId
      expect(name).to.be.equal keyConfig[testId]
      expectTime = ( testId + 1) * 100
      expect(time).to.be.within(expectTime - 50, expectTime + 50)
      testId++

      if testId >= keyConfig.length
        done()

    key.start()
    key.addListener v, listener, id for v, id in keyConfig
    timer.start()
    timerId = setInterval ->
      utils.generateKeyDownEvent keyConfig[eventId]
      eventId++
      clearInterval timerId if eventId >= keyConfig.length
    , 100


  before ->

  after ->

  beforeEach ->

  afterEach ->

