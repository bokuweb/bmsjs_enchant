class Res
  $ = require 'jquery'
  load : (uri)->
    d = new $.Deferred
    $.getJSON uri, (json)=>
      @_objs = json
      @_srcs = []
      for k1, v1 of @_objs
        for k2, v2 of v1
          if v2.src? then @_srcs.push v2.src 
      d.resolve()
    return d.promise()

  get : ->
    srcs: @_srcs
    objs: @_objs

module.exports = Res

