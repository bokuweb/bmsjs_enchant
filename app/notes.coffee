EventObserver = require './eventObserver'
FallObj       = require './fallObj'
KeydownEffect = require './keydownEffect'
Judge         = require './judge'

class Notes extends FallObj

  constructor : (@_sys, @_res, @_timer, @_config)->
    @_notifier = new EventObserver()
    @_keyDownEffect = new KeydownEffect @_sys
    @_judge = new Judge @_config.judge
    @_notes = []
    @_genTime = []

  #
  # create notes
  #
  init : (bms, genTime)->
    @_genTime = genTime
    @_index = 0
    @_notes.length = 0
    @_group = @_sys.createGroup()
    @_sys.addChild @_sys.getCurrentScene(), @_group, @_res.fallObj.zIndex
    @_generate bms, measure, time for time, measure in @_genTime
    xArr = for i in [0...@_res.fallObj.keyNum] then @_calcNoteXCoordinate i
    @_keyDownEffect.init @_res.effect, xArr
    return

  #
  # generate and pool note
  #
  _generate : (bms, measure, time)->
    turntable = @_res.fallObj.noteTurntableImage
    white = @_res.fallObj.noteWhiteImage
    black = @_res.fallObj.noteBlackImage
    fallDist = @_res.fallObj.fallDist
    bpms = bms.bpms
    @_notes[measure] ?= []

    return unless bms.data[measure]?
    for key, i in bms.data[measure].note.key
      for timing, j in key.timing
        switch i
          when 0, 2, 4, 6
            note = @_sys.createSprite white.width, white.height, white.src
          when 1, 3, 5
            note = @_sys.createSprite black.width, black.height, black.src
          when 7
            note = @_sys.createSprite turntable.width, turntable.height, turntable.src
          else throw new Error "error unlnown note"

        note.x = @_calcNoteXCoordinate i
        note.y = -note.height
        note.timing = timing
        note.wav = key.id[j]
        note.key = i
        note.clear = false
        note.hasJudged = false
        @_appendFallParams note, bpms, time, fallDist
        @_notes[measure].push note
    return

  #
  # calculate
  #
  _calcNoteXCoordinate : (id)->
    turntable = @_res.fallObj.noteTurntableImage
    white = @_res.fallObj.noteWhiteImage
    black = @_res.fallObj.noteBlackImage
    offset = @_res.fallObj.offset
    margin = (id + 1) * @_res.fallObj.margin
    switch id
      when 0, 2, 4, 6
        return ~~(id / 2) * (black.width + white.width) + turntable.width + offset + margin
      when 1, 3, 5
        return ~~(id / 2) * (black.width + white.width) + turntable.width + offset + margin + white.width
      when 7
        return offset
      else throw new Error "error unlnown note"

  #
  # start note update
  #
  # @param  isAuto - 
  #
  start : (autoplay = false)->
    @_schedulerId = @_sys.setScheduler @_add
    @_isAuto = autoplay

  stop : -> @_sys.clearScheduler @_schedulerId

  #
  # add event listener
  #
  addListener: (name, listner)->
    @_notifier.on name, listner


  remove : ->
    @stop()
    @_keyDownEffect.remove()
    @_sys.removeChild @_sys.getCurrentScene(), @_group

  #
  # add note to game scene
  # @attention - _add called by window
  #
  _add : =>
    return unless @_genTime[@_index]?
    return unless @_genTime[@_index] <= @_timer.get()
    for note in @_notes[@_index]
      @_sys.addChild @_group, note
      @_sys.setScheduler @_update.bind(@, note), note
    @_index++

  #
  # update note by FPS
  #
  _update : (note)->
    time = @_timer.get()
    while time > note.bpm.timing[note.index]
      if note.index < note.bpm.timing.length - 1 then note.index++
      else break

    diffTime = note.bpm.timing[note.index] - time
    diffDist = diffTime * note.speed[note.index]
    note.y = note.dstY[note.index] - diffDist - note.height
    note.y = note.dstY[note.index] - note.height if note.y > note.dstY[note.index] - note.height

    if note.clear and not note.hasJudged
      note.hasJudged = true
      judgement = @_judge.exec note.diffTime
      @_notifier.trigger judgement
      return

    # FIXME : fix remove timing
    if time > note.timing + @_config.removeTime
      @_sys.removeChild @_group, note
      @_notifier.trigger 'poor' unless note.clear
      return

    # Auto Play
    if @_isAuto
      if time >= note.timing and not note.clear
        @_keyDownEffect.show note.key
        note.clear = true
        note.hasJudged = true
        @_notifier.trigger 'pgreat'
        @_notifier.trigger 'hit', note.wav

  #
  # keydown listener
  #
  onKeydown : (name, time, id)->
    @_keyDownEffect.show id
    for note in @_group.childNodes when note.key is id
      diffTime = note.timing - time
      unless note.clear
        if -@_config.reaction < diffTime < @_config.reaction
          note.clear = true
          note.diffTime = diffTime
          @_notifier.trigger 'hit', note.wav
          return
        else
          @_notifier.trigger 'epoor'
          return

module.exports = Notes
