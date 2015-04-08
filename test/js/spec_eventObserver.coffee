expect = chai.expect
EventObserver = require '../../app/eventObserver'

describe 'EventObserver class test', ()->
  eventObserver = null
  it 'should corresponding listener will called', (done)->
      eventObserver.on 'test1', (name, param)->
        expect(name).to.be.equal 'test1'
        expect(param).to.be.equal 1
      eventObserver.on 'test2', (name, param)->
        expect(name).to.be.equal 'test2'
        expect(param).to.be.equal 2
        
      eventObserver.trigger 'test1', 1
      eventObserver.trigger 'test2', 2
      done()

  before ->
    eventObserver = new EventObserver()

  after ->

  beforeEach ()->

  afterEach ()->
