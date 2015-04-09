expect = chai.expect
Loader = require '../../app/loader'
Sys = require '../../app/gamesys'
utils = require './utils'

describe 'timer class test', ->
  @timeout 30000  
  sys = new Sys 640, 480
  loader = new Loader sys
  it 'should return pgreat judgement', ->
    loader.load 'http://localhost:8080/bms/normal.bms'
      .then (bms)->
        console.dir bms

  before ->

  after ->

  beforeEach ->

  afterEach ->
