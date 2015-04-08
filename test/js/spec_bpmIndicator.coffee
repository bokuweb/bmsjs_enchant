expect = chai.expect
Sys = require '../../app/gamesys'
Timer= require '../../app/timer'
BpmViewer = require '../../app/bpmIndicator'
utils = require './utils'

describe 'BpmIndicator class test', ()->
  capNum = 0
  sys = new Sys 640, 480
  timer = new Timer

  res =
    bpmLabel :
      type  : "label"
      align : "left"
      font  : "12px Arial"
      color : "rgba(0, 0, 0, 0.8)"
      x     : 0
      y     : 100
      z     : 1

  bpms = [
    {val: 100, timing: 0}
    {val: 200, timing: 500}
    {val: 300, timing: 1000}
  ]

  bpmViewer = new BpmViewer sys, timer, bpms


  it 'should bpmlabel updated', (done)->
    timer.start()
    setTimeout ->
      utils.capture "capture/bpmViewer/bpmViewer" + capNum++
    , 50

    setTimeout ->
      utils.capture "capture/bpmViewer/bpmViewer" + capNum++
    , 600

    setTimeout ->
      utils.capture "capture/bpmViewer/bpmViewer" + capNum++
      done()
    , 1100

  before (done)->
    bpmViewer.init res
    sys.start().then -> done()

  after ->
    bpmViewer.remove()

  beforeEach ->
    timer.clear()

  afterEach ->

