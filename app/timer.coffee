class Timer
  constructor : -> @_startTime = 0

  start : -> @_startTime = new Date()

  get : ->
    if @_startTime is 0 then return 0
    currentTime = new Date()
    currentTime - @_startTime

  clear : -> @_startTime = 0

module.exports = Timer
  
