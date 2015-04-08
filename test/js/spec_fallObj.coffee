expect = chai.expect
FallObj = require '../../app/fallObj'

describe 'FallObj class test', ()->
  it 'should correct params appended when start time is 0', ->
    fallObj = new FallObj()
    bpms = [
      {timing: 800  ,val: 140}
      {timing: 1200 ,val: 160}
      {timing: 1600 ,val: 180}
      {timing: 2000 ,val: 200}
      {timing: 2400 ,val: 220}
      {timing: 2800 ,val: 240}
    ]
    node =
      timing: 2400
      bpm :
        timing : []
        val : []
      dstY : []
      speed : []

    fallDistance = 400
    fallObj._appendFallParams node, bpms, 0, fallDistance
    speed = [
      fallDistance / (240000 / 140)
      fallDistance / (240000 / 140)
      fallDistance / (240000 / 160)
      fallDistance / (240000 / 180)
      fallDistance / (240000 / 200)
    ]

    bpmVal = [
      140
      140
      160
      180
      200
    ]

    bpmTiming = [
      800
      1200
      1600
      2000
      2400
    ]

    dstY = [ ]

    expect(node.speed.toString()).to.be.equal speed.toString()
    expect(node.bpm.timing.toString()).to.be.equal bpmTiming.toString()
    expect(node.bpm.val.toString()).to.be.equal bpmVal.toString()

    for v, i in bpmTiming by -1
      if i is node.dstY.length-1
        dstY[i] = fallDistance
      else
        dstY[i] = dstY[i+1] - (speed[i+1] * (bpmTiming[i+1]-bpmTiming[i]))
    expect(node.dstY.toString()).to.be.equal dstY.toString()

  it 'should correct params appended when start time is 1000', ->
    fallObj = new FallObj()
    bpms = [
      {timing: 800  ,val: 140}
      {timing: 1200 ,val: 160}
      {timing: 1600 ,val: 180}
      {timing: 2000 ,val: 200}
      {timing: 2400 ,val: 220}
      {timing: 2800 ,val: 240}
    ]
    node =
      timing: 2600
      bpm :
        timing : []
        val : []
      dstY : []
      speed : []

    fallDistance = 400
    fallObj._appendFallParams node, bpms, 1000, fallDistance
    speed = [
      fallDistance / (240000 / 140)
      fallDistance / (240000 / 160)
      fallDistance / (240000 / 180)
      fallDistance / (240000 / 200)
      fallDistance / (240000 / 220)
    ]

    bpmVal = [
      140
      160
      180
      200
      220
    ]

    bpmTiming = [
      1200
      1600
      2000
      2400
      2600
    ]

    dstY = [ ]

    expect(node.speed.toString()).to.be.equal speed.toString()
    expect(node.bpm.timing.toString()).to.be.equal bpmTiming.toString()
    expect(node.bpm.val.toString()).to.be.equal bpmVal.toString()

    for v, i in bpmTiming by -1
      if i is node.dstY.length-1
        dstY[i] = fallDistance
      else
        dstY[i] = dstY[i+1] - (speed[i+1] * (bpmTiming[i+1]-bpmTiming[i]))
    expect(node.dstY.toString()).to.be.equal dstY.toString()

  before ->

  after ->

  beforeEach ->

  afterEach ->
