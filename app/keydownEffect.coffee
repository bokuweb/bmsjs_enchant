class KeydownEffect
  constructor : (@_sys)->
    @_KeyDownEffect = []
  #
  # initialize Effect
  #
  init : (res, xArr)->
    @_KeyDownEffect.length = 0
    for v, i in xArr
      switch i
        when 0, 2, 4, 6
          @_KeyDownEffect[i] = @_sys.createSprite res.whiteKeydownImage.width, res.whiteKeydownImage.height, res.whiteKeydownImage.src
          @_KeyDownEffect[i].height = res.whiteKeydownImage.height
          @_KeyDownEffect[i].width = res.whiteKeydownImage.width
          @_KeyDownEffect[i].x = v
        when 1, 3, 5
          @_KeyDownEffect[i] = @_sys.createSprite res.blackKeydownImage.width, res.blackKeydownImage.height, res.blackKeydownImage.src
          @_KeyDownEffect[i].height = res.blackKeydownImage.height
          @_KeyDownEffect[i].width = res.blackKeydownImage.width
          @_KeyDownEffect[i].x = v
        when 7
          @_KeyDownEffect[i] = @_sys.createSprite res.turntableKeydownImage.width, res.turntableKeydownImage.height, res.turntableKeydownImage.src
          @_KeyDownEffect[i].height = res.turntableKeydownImage.height
          @_KeyDownEffect[i].width = res.turntableKeydownImage.width
          @_KeyDownEffect[i].x = v
        else
      @_KeyDownEffect[i].y = res.y
      @_sys.addChild @_sys.getCurrentScene(), @_KeyDownEffect[i], res.z
      @_sys.setOpacity @_KeyDownEffect[i], 0
    return

  show : (id)->
    @_sys.setOpacity @_KeyDownEffect[id], 1
    @_sys.setScheduler @_fadeOut.bind(@, @_KeyDownEffect[id]), @_KeyDownEffect[id]

  remove : ->
    for v in @_KeyDownEffect
      @_sys.removeChild @_sys.getCurrentScene(), v

  _fadeOut : (effect)->
    opacity = @_sys.getOpacity effect
    if opacity > 0
      opacity -= 0.08
      if opacity <= 0
        @_sys.setOpacity effect, 0
        @_sys.clearScheduler effect
      else @_sys.setOpacity effect, opacity

module.exports = KeydownEffect
