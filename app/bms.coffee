Sys   = require './gamesys'
Timer = require './timer'

class Bms

  constructor : ()->
    @_sys = new Sys 640, 480
    @_timer = new Timer()
    #@_sys.preload [res.test1, res.test2, res.test3]
    @_sys.start().then ->
      console.log "loaded"
