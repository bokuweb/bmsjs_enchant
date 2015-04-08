expect = chai.expect
Sys = require '../../app/gamesys'
utils = require './utils'

res =
  test1 : './img/test1.png'
  test2 : './img/test2.png'
  test3 : './img/test3.png'

describe 'game system test', (done)->
  sys = null
  capNum = 0
  test1 = null
  test2 = null
  test3 = null
  label = null

  it 'sprite add to rootsecne with zindex test', (done)->
    test1 = sys.createSprite 32, 32, res.test1
    test1.x = 0
    test1.y = 0
    sys.addChild sys.getCurrentScene(), test1, 0
    test2 = sys.createSprite 32, 32, res.test2
    test2.x = 10
    test2.y = 10
    sys.addChild sys.getCurrentScene(), test2, 2
    test3 = sys.createSprite 32, 32, res.test3
    test3.x = 20
    test3.y = 20
    sys.addChild sys.getCurrentScene(), test3, 1
    expect(sys.getChildNum(sys.getCurrentScene())).to.be.equal 3
    setTimeout ->
      utils.capture "capture/sys/sys" + capNum++
      done()
    , 50

  it 'sprite remove from rootsecne test', (done)->
    sys.removeChild sys.getCurrentScene(), test1
    sys.removeChild sys.getCurrentScene(), test2
    sys.removeChild sys.getCurrentScene(), test3
    expect(sys.getChildNum(sys.getCurrentScene())).to.be.equal 0
    setTimeout ->
      utils.capture "capture/sys/sys" + capNum++
      done()
    , 50

  it 'sprite add to rootsecne without zindex test', (done)->
    test1 = sys.createSprite 32, 32, res.test1
    test1.x = 0
    test1.y = 0
    sys.addChild sys.getCurrentScene(), test1
    test2 = sys.createSprite 32, 32, res.test2
    test2.x = 10
    test2.y = 10
    sys.addChild sys.getCurrentScene(), test2
    test3 = sys.createSprite 32, 32, res.test3
    test3.x = 20
    test3.y = 20
    sys.addChild sys.getCurrentScene(), test3
    expect(sys.getChildNum(sys.getCurrentScene())).to.be.equal 3
    setTimeout ->
      utils.capture "capture/sys/sys" + capNum++
      done()
    , 50

  it 'sprite update test', (done)->
    sys.setScheduler ->
      @x += 1
      if @x > 40
        sys.removeChild sys.getCurrentScene(), @
        setTimeout ->
          utils.capture "capture/sys/sys" + capNum++
          expect(sys.getChildNum(sys.getCurrentScene())).to.be.equal 0
          done()
        , 10
    , test1

    sys.setScheduler  ->
      @x += 1
      if @x > 40 then sys.removeChild sys.getCurrentScene(), @
    , test2

    sys.setScheduler ->
      @x += 1
      if @x > 40 then sys.removeChild sys.getCurrentScene(), @
    , test3


  it 'label add to rootsecne with zindex test', (done)->
    label = sys.createLabel 'Arial', 'rgba(0, 0, 0, 0.8)', 'left'
    label.x = 0
    label.y = 0
    sys.setText label, 'this is test message!!'
    sys.addChild sys.getCurrentScene(), label, 1
    expect(sys.getChildNum(sys.getCurrentScene())).to.be.equal 1
    setTimeout ->
      utils.capture "capture/sys/sys" + capNum++
      done()
    , 50

  it 'label remove from rootsecne test', (done)->
    sys.removeChild sys.getCurrentScene(), label
    expect(sys.getChildNum(sys.getCurrentScene())).to.be.equal 0
    setTimeout ->
      utils.capture "capture/sys/sys" + capNum++
      done()
    , 50

  before (done)->
    sys = new Sys 640, 480
    sys.preload [res.test1, res.test2, res.test3]
    sys.start().then ->
      done()

  after ()->

  beforeEach ()->

  afterEach ()->

