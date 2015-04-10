expect = chai.expect
Nodes = require '../../app/measureNodes'
Sys = require '../../app/gamesys'
Timer = require '../../app/timer'
utils = require './utils'

describe 'MeasureNodes class test', ()->
  @timeout 10000  
  capNum = 0
  removeNum = 0
  sys = new Sys 640, 480
  timer = new Timer()
  nodes = new Nodes sys, timer
  res =
    fallDist : 400
    nodeImage : 
      type : "image"
      src : "../res/node.png"
      width : 194
      height : 1
      x : 0
      y : -10
      z : 1

  node = [
    {timing : 2000}
    {timing : 4000}
    {timing : 6000}
  ]

  bpms = [
    {timing: 800  ,val: 140}
    {timing: 1200 ,val: 160}
    {timing: 1600 ,val: 180}
    {timing: 2000 ,val: 200}
    {timing: 2400 ,val: 220}
    {timing: 2800 ,val: 240}
  ]

  correctGenerationtiming = [
    457
    3000
    5000
  ]
  fallDistance = 400

  it 'should return node generation timing list when nodes created', ->
    generationTime =  nodes.init res, bpms, node
    expect generationTime.toString()
      .to.be.equal correctGenerationtiming.toString()

  it 'should node fall and call remove listenr when over fallDistance', (done)->
    nodes.addListener 'remove', (name, param)->
      console.log "node remove time = " + param 
      removeNum++
      if removeNum is node.length
        nodes.stop()
        done()
    nodes.start()
    timer.start()

  before (done)->
    sys.preload [res.nodeImage.src]
    sys.start().then -> done()

  after -> 

  beforeEach ->

  afterEach ->

