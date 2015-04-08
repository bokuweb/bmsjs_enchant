capture = (name)-> if window.callPhantom? then callPhantom {'screenshot': name}

generateKeyDownEvent = (key)->
  event = document.createEvent "Event"
  event.initEvent "keydown", true, true
  event.keyCode = key
  document.dispatchEvent event

module.exports =
  capture : capture
  generateKeyDownEvent : generateKeyDownEvent
