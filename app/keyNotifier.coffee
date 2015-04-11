EventObserver = require './eventObserver'
$ = require 'jquery'

class KeyNotifier extends EventObserver
  constructor : (@_timer)->
    super()

  start : ->
    document.addEventListener 'keydown', @_checkKey, false

  stop : ->
    document.removeEventListener 'keydown', @_checkKey, false

  #
  # add event listener
  #
  # @param name - key name
  # @param id - key ID
  # @param listener - listener
  #
  addListener: (key, listener, id)->
    @on key, listener, id

  _checkKey : (e)=>
    console.log "_checkkey"
    time = @_timer.get()
    @trigger e.keyCode, time

module.exports = KeyNotifier
