class Bmp
  POOR_INDICATOR_TIME : 200

  constructor : (@_sys, @_timer, @_srcs, @_bmps)->

  init : (res)->
    @_index = 0
    @_isPoor = false
    @_bmpSprite = @_sys.createSprite res.bmpImage.width, res.bmpImage.height, res.bmpImage.src
    @_bmpSprite.x = res.bmpImage.x
    @_bmpSprite.y = res.bmpImage.y
    @_sys.setImage @_bmpSprite, @_srcs[_bmps[0].id] if @_bmps[0].id?
    @_sys.addChild @_sys.getCurrentScene(), @_bmpSprite, res.bmpImage.z

  start : ->
    @_sys.setScheduler @_update, @_bpmSprite

  remove : ->
    @_sys.removeChild @_sys.getCurrentScene(), @_bmpSprite

  poorListener : ->
    @_isPoor = true
    @_sys.setImage @_bmpSprite, @_srcs[0]
    setTimeout @_disablePoor, @POOR_INDICATOR_TIME

  _disablePoor : -> @_isPoor = false

  _update : ->
    time = @_timer.get()
    if time > @_bpms[@_index]?.timing
      @_sys.setImage @_bmpSprite, @_srcs[@_bmps[0].id] unless @_isPoor
      @_index++

module.exports = Bmp
