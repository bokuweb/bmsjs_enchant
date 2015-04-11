Sys = require './gamesys'
Timer = require './timer'
Res = require './resource'
Loader = require './loader'
MeasureNodes  = require './measureNodes'
Notes  = require './notes'

class Bms

  constructor : ->
    @_sys = new Sys 640, 480
    @_timer = new Timer()
    @_res = new Res()
    @_loader = new Loader @_sys
    @_measureNodes = new MeasureNodes @_sys, @_timer


  start : (bmsUrl, themeUrl)->
    load = =>
      console.dir @_res.get().srcs
      @_loader.load bmsUrl, @_res.get().srcs

    @_res.load themeUrl
      .then load
      .then @_init

  _init : (@_bms)=>
    console.dir @_bms
    console.log "initialize..."
    genTime =  @_measureNodes.init @_res.get().objs.fallObj, @_bms.bpms, @_bms.data
    console.dir genTime
    config =
      reaction : 200
      removeTime : 200
      judge :
        pgreat : 10
        great  : 50
        good   : 100
        bad    : 150
        poor   : 200
    @_notes = new Notes @_sys, {fallObj:@_res.get().objs.fallObj, effect:@_res.get().objs.keydownEffect}, @_timer, config
    @_notes.init @_bms, genTime
    @_play()

  _play : ->
    console.log "play..."
    @_measureNodes.start()
    @_notes.start()
    @_timer.start()


bms = new Bms()
bms.start 'http://localhost:8080/bms/normal.bms', 'http://localhost:8080/res/resource.json'
