expect = chai.expect
Res = require '../../app/resource'

describe 'resource class test', ->
  URI = './js/resource_test.json'
  srcs = ["./res/test2.png", "./res/test.png", "./res/gauge.png"]
  res = new Res()

  it 'should loaded result match srcs', (done)->
    res.load URI
      .then ()->
        expect(res.get().srcs.toString()).to.be.equal srcs.toString()
        done()

  before ()->

  after ()->

  beforeEach ()->

  afterEach ()->
