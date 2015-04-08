$ = require 'jquery'
Parser = require './bmsParser'

class Loader

  constructor : (@_sys)->

  # TODO : add zip loader
  load : (url, @_srcs)->
    d = new $.Deferred
    m = /^.+\//.exec url
    @_prefix = m[0] if m
    console.log @_prefix
    $.ajax
      url: url
      success: @_start
    d.promise()

  _start : (bms) =>
    parser = new Parser()
    @_bms = parser.parse bms

    @_sys.preload @_srcs if @srcs?

    # preload *.wav
    @_sys.preload @_prefix + v for k, v of @_bms.wav when v?

    # preload *.bmp
    @_sys.preload @_prefix + v for k, v of @_bms.bmp when v?

    # loadend
    @_sys.start().then -> d.resolve @_bms

module.exports = Loader
