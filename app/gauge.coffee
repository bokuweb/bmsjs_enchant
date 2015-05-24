class Gauge
  constructor : (@_sys)->
    @_gaugeSprite = []

  init : (res, config)->
    @_initRate = @_rate = config.initRate
    @_greatIncVal = config.greatIncVal
    @_goodIncVal = config.goodIncVal
    @_badDecVal = config.badDecVal
    @_poorDecVal = config.poorDecVal
    @_num = config.num
    @_clearVal = config.clearVal

    for i in [0...@_num]
      @_gaugeSprite[i] = @_sys.createSprite res.gaugeImage.width, res.gaugeImage.height, res.gaugeImage.src
      @_gaugeSprite[i].x = res.gaugeImage.x + i * res.gaugeImage.width
      @_gaugeSprite[i].y = res.gaugeImage.y
      @_sys.addChild @_sys.getCurrentScene(), @_gaugeSprite[i], @_gaugeSprite[i].z

    @_rateLabel = @_sys.createLabel res.rateLabel.font, res.rateLabel.color, res.rateLabel.align
    @_rateLabel.x = res.rateLabel.x
    @_rateLabel.y = res.rateLabel.y
    @_sys.setText @_rateLabel, ~~@_rate + "%"
    @_sys.addChild @_sys.getCurrentScene(), @_rateLabel, res.rateLabel.z
    @_render()

  get : -> ~~(@_rate.toFixed())

  # FIXME : use reques animatiomn frame
  start : (period)-> @_intervalId = setInterval @_render, period

  stop : -> clearInterval @_intervalId

  clear : ->
    @_rate = @_initRate
    @_render()

  remove : ->
    @stop()
    @_sys.removeChild @_sys.getCurrentScene(), @_gaugeSprite[i] for i in [0...@_num]
    @_sys.removeChild @_sys.getCurrentScene(), @_rateLabel

  update : (judge) ->
    switch judge
      when "pgreat", "great"
        @_rate = if @_rate + @_greatIncVal > 100 then 100 else @_rate + @_greatIncVal
      when "good"
        @_rate = if @_rate + @_goodIncVal > 100 then 100 else @_rate + @_goodIncVal
      when "bad"
        @_rate = if @_rate - @_badDecVal < 2 then 2 else @_rate - @_badDecVal
      when "poor"
        @_rate = if @_rate - @_poorDecVal < 2 then 2 else @_rate - @_poorDecVal
      else
        @_rate = if @_rate - @_poorDecVal < 2 then 2 else @_rate - @_poorDecVal

    @_sys.setText @_rateLabel, ~~(@_rate.toFixed()) + "%"
    @_render()

  _render : =>
    for i in [0...@_num]
      if i > @_clearVal
        if @_rate - 6 <= i * 2 < @_rate - 2
          @_sys.setFrame @_gaugeSprite[i], ~~(Math.random() * 2) * 2
        else if @_rate - 2 >= i * 2 then @_sys.setFrame @_gaugeSprite[i], 0
        else @_sys.setFrame @_gaugeSprite[i], 2
      else
        if @_rate - 6 <= i * 2 < @_rate - 2 then @_sys.setFrame @_gaugeSprite[i], ~~(Math.random() * 2) * 2 + 1
        else if @_rate - 2 >= i * 2 then @_sys.setFrame @_gaugeSprite[i], 1
        else @_sys.setFrame @_gaugeSprite[i], 3
    return

module.exports = Gauge
