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
      success: (bms)=>
        parser = new Parser()
        @_bms = parser.parse bms
        #console.dir @_bms
        @_sys.preload @_srcs if @srcs?
        # preload *.wav
        @_sys.preload @_prefix + v for k, v of @_bms.wav when v?
        # preload *.bmp
        @_sys.preload @_prefix + v for k, v of @_bms.bmp when v?
        # loadend
        @_sys.start().then =>
          d.resolve @_bms
    d.promise()

module.exports = Loader
