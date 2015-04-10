Sys = require './gamesys'
Timer = require './timer'
Res = require './resource'
Loader = require './loader'
Nodes  = require './measureNodes'

class Bms

  constructor : ->
    @_sys = new Sys 640, 480
    @_timer = new Timer()
    @_res = new Res()
    @_loader = new Loader @_sys
    @_nodes = new Nodes @_sys, @_timer

  start : (bmsUrl, themeUrl)->
    load = =>
      console.dir @_res.get().srcs
      @_loader.load bmsUrl, @_res.get().srcs

    @_res.load themeUrl
      .then(load)
      .then(@_init)

  _init : (@_bms)=>
    console.dir @_bms
    console.log "initialize..."
    genTime =  @_nodes.init @_res.get().objs.fallObj, @_bms.bpms, @_bms.data
    @_play()

  _play : ->
    console.log "play..."
    @_nodes.start()
    @_timer.start()


bms = new Bms()
bms.start 'http://localhost:8080/bms/normal.bms', 'http://localhost:8080/res/resource.json'
