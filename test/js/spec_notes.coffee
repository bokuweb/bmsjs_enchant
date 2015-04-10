expect = chai.expect
Notes = require '../../app/notes'
Sys = require '../../app/gamesys'
Timer = require '../../app/timer'
utils = require './utils'
$ = require 'jquery'

describe 'Notes class test', ()->
  @timeout 10000  
  capNum = 0
  id = 0
  sys = new Sys 640, 480
  timer = new Timer()
  res = 
    fallObj :
      fallDist : 400
      keyNum : 8
      offset : 35
      margin : 2
      zIndex : 4
      noteTurntableImage : 
        type : "image"
        src : "../res/note-turntable.png"
        width : 41
        height : 6
        x : 0
        y : -10
        z : 1
      noteWhiteImage : 
        type : "image"
        src : "../res/note-white.png"
        width : 22
        height : 6
        x : 0
        y : -10
        z : 1
      noteBlackImage : 
        type : "image"
        src : "../res/note-black.png"
        width : 17
        height : 6
        x : 0
        y : -10
        z : 1
    effect : 
      y : 0
      z : 1
      turntableKeydownImage : 
        type : "image"
        src : "../res/turntable-keydown.png"
        width : 41
        height : 316
      whiteKeydownImage : 
        type : "image"
        src : "../res/white-keydown.png"
        width : 22
        height : 316
      blackKeydownImage : 
        type : "image"
        src : "../res/black-keydown.png"
        width : 17
        height : 316

  config =
    reaction : 200
    removeTime : 5000
    judge :
      pgreat : 10
      great : 50
      good : 100
      bad : 150
      poor : 200

  note = new Notes sys, res, timer, config

  data = []
  data.push
    note :
      key : [
        {id : [0], timing : [1000]}
        {id : [1], timing : [1100]}
        {id : [2], timing : [1200]}
        {id : [3], timing : [1300]}
        {id : [4], timing : [1400]}
        {id : [5], timing : [1500]}
        {id : [6], timing : [1600]}
        {id : [7], timing : [1700]}
      ]

  data.push
    note : 
      key : [
        {id : [14], timing : [2700]}
        {id : [13], timing : [2600]}
        {id : [12], timing : [2500]}
        {id : [11], timing : [2400]}
        {id : [10], timing : [2300]}
        {id : [9], timing : [2200]}
        {id : [8], timing : [2100]}
        {id : [15], timing : [2800]}
      ]

  data.push
    note : 
      key : [
        {id : [22], timing : [3700]}
        {id : [21], timing : [3600]}
        {id : [20], timing : [3500]}
        {id : [19], timing : [3400]}
        {id : [18], timing : [3300]}
        {id : [17], timing : [3200]}
        {id : [16], timing : [3100]}
        {id : [23], timing : [3800]}
      ]

  bpms = [
    {timing: 800  ,val: 140}
    {timing: 1200 ,val: 160}
    {timing: 1600 ,val: 180}
    {timing: 2000 ,val: 400}
    {timing: 2400 ,val: 50}
    {timing: 2800 ,val: 240}
  ]

  bms = 
   bpms : bpms
   data : data

  genTime = [0, 1000, 2000, 3000]

  judgeNum =
    pgreat : 0
    great : 0
    good : 0
    bad : 0
    poor : 0
    epoor : 0

  wavNum = 0

  keydownArr = [
    {key : 0, timing : 1000}
    {key : 1, timing : 1100}
    {key : 2, timing : 1200}
    {key : 3, timing : 1300}
    {key : 4, timing : 1400}
    {key : 5, timing : 1500}
    {key : 6, timing : 1600}
    {key : 7, timing : 1700}
    {key : 6, timing : 2100}
    {key : 5, timing : 2200}
    {key : 4, timing : 2300}
    {key : 3, timing : 2400}
    {key : 2, timing : 2500}
    {key : 1, timing : 2600}
    {key : 0, timing : 2700}
    {key : 7, timing : 2800}
    {key : 6, timing : 3100}
    {key : 5, timing : 3200}
    {key : 4, timing : 3300}
    {key : 3, timing : 3400}
    {key : 2, timing : 3500}
    {key : 1, timing : 3600}
    {key : 0, timing : 3700}
    {key : 7, timing : 3800}
    ]
    
  note.addListener 'pgreat', (name)->
    console.log name
    judgeNum.pgreat++

  note.addListener 'great', (name)->
    console.log name
    judgeNum.great++

  note.addListener 'good', (name)->
    console.log name
    judgeNum.good++

  note.addListener 'bad', (name)->
    console.log name
    judgeNum.bad++

  note.addListener 'poor', (name)->
    console.log name
    judgeNum.poor++

  note.addListener 'epoor', (name)->
    console.log name
    judgeNum.epoor++

  note.addListener 'hit', (name, wav)->
    console.log "hit wav id = #{wav}"
    wavNum++

  it 'note create and update test with auto mode',(done)->
    note.init bms, genTime
    note.start on
    timer.start()
    promises = []
    for n in bms.data
      for key in n.note.key
        for time in key.timing
          promises.push do ->
            d = new $.Deferred
            setTimeout ->
              utils.capture "capture/notes/notes" + capNum++
              d.resolve()
            , time
            d.promise()

    $.when(promises...).then ->
      # wait note remove
      setTimeout ->
        expect(judgeNum.pgreat).to.be.equal 24
        expect(judgeNum.great).to.be.equal 0
        expect(judgeNum.good).to.be.equal 0
        expect(judgeNum.bad).to.be.equal 0
        expect(judgeNum.poor).to.be.equal 0
        expect(judgeNum.epoor).to.be.equal 0
        expect(wavNum).to.be.equal 24
        done()
      , 1000

  
  it 'note create and update test without auto mode',(done)->
    note.init bms, genTime
    note.start off
    timer.start()
    promises = []
    index = 0
    id = null

    for n in bms.data
      for key in n.note.key
        for time in key.timing
          promises.push do ->
            d = new $.Deferred
            setTimeout ->
              utils.capture "capture/notes/notes" + capNum++
              d.resolve()
            , time
            d.promise()

    id = setInterval ()->
      if timer.get() >= keydownArr[index].timing
        #console.log keydownArr[index].timing + ((index % 5) * 50)
        note.onKeydown "keydown", keydownArr[index].timing - ((index % 5) * 50) + 5, keydownArr[index].key 
        index++
        clearInterval id if index >= keydownArr.length
    , 50

    $.when(promises...).then ->
      # wait note remove
      setTimeout ->
        expect(judgeNum.pgreat).to.be.equal 5
        expect(judgeNum.great).to.be.equal 5
        expect(judgeNum.good).to.be.equal 5
        expect(judgeNum.bad).to.be.equal 5
        expect(judgeNum.poor).to.be.equal 4
        expect(judgeNum.epoor).to.be.equal 0
        expect(wavNum).to.be.equal 24
        done()
      , 1000

  before (done)->
    sys.preload [
      res.fallObj.noteTurntableImage.src
      res.fallObj.noteWhiteImage.src
      res.fallObj.noteBlackImage.src
      res.effect.turntableKeydownImage.src
      res.effect.blackKeydownImage.src
      res.effect.whiteKeydownImage.src
      ]
    sys.start().then -> done()

  after -> 

  beforeEach ->
    judgeNum =
      pgreat : 0
      great : 0
      good : 0
      bad : 0
      poor : 0
      epoor : 0
    wavNum = 0

  afterEach ->
    timer.clear()
    note.remove()

