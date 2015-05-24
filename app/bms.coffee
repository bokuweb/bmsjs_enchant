Sys          = require './gamesys'
Timer        = require './timer'
Res          = require './resource'
Loader       = require './loader'
MeasureNodes = require './measureNodes'
Notes        = require './notes'
Audio        = require './audio'
KeyNotifier  = require './keyNotifier'
Skin         = require './skin'
Gauge        = require './gauge'

class Bms
  constructor : ->
    @_sys = new Sys 640, 480
    @_timer = new Timer()
    @_res = new Res()
    @_loader = new Loader @_sys
    @_measureNodes = new MeasureNodes @_sys, @_timer
    @_keyNotifier = new KeyNotifier @_timer
    @_gauge = new Gauge @_sys

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

    skin = new Skin @_sys
    skin.init @_res.get().objs.skin
    # TODO: move
    config =
      reaction : 200
      removeTime : 200
      judge :
        pgreat : 10
        great  : 50
        good   : 100
        bad    : 150
        poor   : 200

    @_gauge.init @_res.get().objs.gauge,
      initRate    : 100
      greatIncVal : 1
      goodIncVal  : 0.5
      badDecVal   : -0.2
      poorDecVal  : -0.4
      num         : 50
      clearVal    : 40
    @_gauge.start 200

    @_notes = new Notes @_sys, {fallObj:@_res.get().objs.fallObj, effect:@_res.get().objs.keydownEffect}, @_timer, config
    @_notes.init @_bms, genTime
    @_notes.addListener 'hit', @_onHit
    @_notes.addListener 'judge', @_onJudge
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

  _onHit : (name, wavId) =>
    @_audio.play wavId

  _onJudge : (name, judgement) =>
    console.log judgement


bms = new Bms()
bms.start 'http://localhost:8080/bms/dq.bms', 'http://localhost:8080/res/skin.json'
