class Audio
  _wav : []
  _index : 0
  _scheduleId : null

  constructor : (@_sys, @_timer, @_bgms)->

  init : (res, prefix)->
    @_index = 0
    # configure wave file
    @_wav[k] = @_sys.creatAudio prefix + v for k, v of res

  play : (id)-> @_sys.playAudio @_wav[id]

  bgmStart : ->
    @_scheduleId = @_sys.setScheduler @_update

  bgmStop : -> @_sys.clearScheduler @_schedulerId

  hasAllBgmPlayEnd : ->
    for k, v of @_wav when v.currentTime < v.duration
      return false
    return true

  _update : =>
    time = @_timer.get()
    while time >= @_bgms[@_index]?.timing
      @play @_bgms[@_index].id
      @_index++

module.exports = Audio
