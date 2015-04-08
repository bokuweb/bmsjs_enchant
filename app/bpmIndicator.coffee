class BpmIndicator
  constructor : (@_sys, @_timer, @_bpms)->

  init : (res)->
    @_index = 0
    @_bpmLabel = @_sys.createLabel res.bpmLabel.font, res.bpmLabel.color, res.bpmLabel.align
    @_bpmLabel.x = res.bpmLabel.x
    @_bpmLabel.y = res.bpmLabel.y
    @_sys.setText @_bpmLabel, @_bpms[0]
    @_sys.addChild @_sys.getCurrentScene(), @_bpmLabel, res.bpmLabel.z
    @_sys.setScheduler @_update.bind(@, @_bpmLabel), @_bpmLabel

  remove : -> @_sys.removeChild @_sys.getCurrentScene(), @_bpmLabel

  _update : (label)->
    time = @_timer.get()
    if time > @_bpms[@_index]?.timing
      @_sys.setText label, @_bpms[@_index].val
      @_index++

module.exports = BpmIndicator
