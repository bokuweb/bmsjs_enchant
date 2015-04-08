expect = chai.expect
Judge  = require '../../app/judge'

describe 'Judge class test', ->
  judge = null
  config =
    pgreat : 10
    great  : 20
    good   : 50
    bad    : 100
    poor   : 200

  it 'should return pgreat judgement', ->
    judge = new Judge config
    expect(judge.exec 0).to.be.equal 'pgreat'
    expect(judge.exec -9).to.be.equal 'pgreat'
    expect(judge.exec 9).to.be.equal 'pgreat'

  it 'should return great judgement', ->
    judge = new Judge config
    expect(judge.exec -10).to.be.equal 'great'
    expect(judge.exec 10).to.be.equal 'great'
    expect(judge.exec 19).to.be.equal 'great'
    expect(judge.exec -19).to.be.equal 'great'

  it 'should return good judgement', ->
    judge = new Judge config
    expect(judge.exec -20).to.be.equal 'good'
    expect(judge.exec 20).to.be.equal 'good'
    expect(judge.exec 49).to.be.equal 'good'
    expect(judge.exec -49).to.be.equal 'good'

  it 'should return bad judgement', ->
    judge = new Judge config
    expect(judge.exec -50).to.be.equal 'bad'
    expect(judge.exec 50).to.be.equal 'bad'
    expect(judge.exec 99).to.be.equal 'bad'
    expect(judge.exec -99).to.be.equal 'bad'

  it 'should return poor judgement', ->
    judge = new Judge config
    expect(judge.exec -100).to.be.equal 'poor'
    expect(judge.exec 100).to.be.equal 'poor'
    expect(judge.exec 200).to.be.equal 'poor'
    expect(judge.exec 201).to.be.equal 'poor'

  before ->

  after ->

  beforeEach ->

  afterEach ->
