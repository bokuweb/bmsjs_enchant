Sys = require './gamesys'
Timer = require './timer'
Res = require './resource'
Loader = require './loader'
MeasureNodes  = require './measureNodes'
Notes = require './notes'
Audio = require './audio'
KeyNotifier = require './keyNotifier'

class Bms

  constructor : ->
    @_sys = new Sys 640, 480
    @_timer = new Timer()
    @_res = new Res()
    @_loader = new Loader @_sys
    @_measureNodes = new MeasureNodes @_sys, @_timer
    @_keyNotifier = new KeyNotifier @_timer

  start : (bmsUrl, themeUrl)->
    m = /^.+\//.exec bmsUrl
    @_prefix = m[0] if m
    load = =>
      console.dir @_res.get().srcs
      @_loader.load bmsUrl, @_prefix, @_res.get().srcs

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
    @_notes.addListener 'hit', @_onHit
    @_audio = new Audio @_sys, @_timer, @_bms.bgms
    @_audio.init @_bms.wav, @_prefix
    # FIXME : move to argument
    keyConfig = [
      'Z'.charCodeAt(0)
      'S'.charCodeAt(0)
      'X'.charCodeAt(0)
      'D'.charCodeAt(0)
      'C'.charCodeAt(0)
      'F'.charCodeAt(0)
      'V'.charCodeAt(0)
      16]
    @_keyNotifier.addListener v, @_notes.onKeydown, id for v, id in keyConfig
    @_play()

  _play : ->
    console.log "play..."
    @_measureNodes.start()
    @_notes.start on
    @_audio.bgmStart()
    @_keyNotifier.start()
    @_timer.start()

  _onHit : (name, wavId)=>
    @_audio.play wavId

bms = new Bms()
bms.start 'http://localhost:8080/bms/dq.bms', 'http://localhost:8080/res/resource.json'
