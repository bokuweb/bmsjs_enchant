$ = require 'jquery'
Parser = require './bmsParser'

class Loader

  constructor : (@_sys)->

  # TODO : add zip loader
  load : (url, prefix, @_srcs)->
    d = new $.Deferred
    $.ajax
      url: url
      success: (bms)=>
        parser = new Parser()
        @_bms = parser.parse bms
        #console.dir @_bms
        @_sys.preload @_srcs
        # preload *.wav
        @_sys.preload prefix + v for k, v of @_bms.wav when v?
        # preload *.bmp
        @_sys.preload prefix + v for k, v of @_bms.bmp when v?
        # loadend
        @_sys.start().then => d.resolve @_bms
    d.promise()

module.exports = Loader
