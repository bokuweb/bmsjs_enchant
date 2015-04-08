class GameSys
  _instance = null
  _scheduler = []
  
  GameSys = (w, h)->  _instance ?= new GameSysPrivate w, h

  class GameSysPrivate
    require './enchant'
    $ = require 'jquery'
    FPS = 60
    _vZIndex = []
    _game = null

    constructor : (w, h)->
      enchant()
      _game = new Core w, h
      _game.fps = FPS
      _vZIndex.length = 0

    preload : (objs)-> _game.preload objs

    start : ->
      d = new $.Deferred
      _game.start()
      _game.onload = -> d.resolve()
      d.promise()

    getCurrentScene : -> _game.currentScene

    getChildNum : (obj)-> obj.childNodes.length

    createScene : ()-> scene = new Scene()

    replaceScene : (scene)->
      _game.replaceScene scene
      _vZIndex.length = 0

    createSprite : (w, h, src)->
      sprite = new Sprite w, h
      sprite.image = _game.assets[src]
      sprite

    setImage : (obj, src)->
      obj.image = _game.assets[src]

    setOpacity : (obj, opacity)->
      obj.opacity = opacity

    getOpacity : (obj)->
      obj.opacity
      
    createLabel : (font, color, align)->
      label = new Label()
      label.font = font
      label.color = color
      label.textAlign = align
      label

    creatAudio : (src)-> _game.assets[src]

    playAudio : (audio)-> audio.play true

    createGroup : -> new Group()

    createNode : -> new Node()

    setScheduler: (func, obj)->
      if obj?
        obj.addEventListener "enterframe", func
        return obj
      else
        for v in _scheduler
          unless v.active
            v.active = true
            v.addEventListener "enterframe", func
            return v
        node = new Node()
        node.active = true
        @addChild @getCurrentScene(), node
        node.addEventListener "enterframe", func
        _scheduler.push node
        node

    clearScheduler : (obj)->
      obj.clearEventListener "enterframe"
      obj.active = false

    setText : (label, text)-> label.text = text

    addChild : (dist, obj, z)->
      obj.z = z
      if z?
        for v, i in _vZIndex when v.z > z
          dist.insertBefore obj, v.obj
          _vZIndex.splice i, 0, {obj, z}
          return
        dist.addChild obj
        _vZIndex.push {obj, z}
        return
      else dist.addChild obj

    removeChild : (dist, obj)->
      if obj.z?
        for v, i in _vZIndex when v.obj is obj
          _vZIndex.splice i, 1
          dist.removeChild obj
          return
      else dist.removeChild obj
      obj.clearEventListener "enterframe"
      return

    poolObj : (pool, obj)->
      pool.push obj
      obj.active = false
      if obj.addEventListener then obj.addEventListener "removed", @_deactive

    getObj : (pool)->
      for v, i in pool
        unless v.active
          v.active = true
          pool.lastObj = i
          return value
      console.log "error sprite pool empty"
      false

    getLastActiveObj : (pool)-> pool[pool.lastObj]

    setFrame : (obj, num) -> obj.frame = num

    allocateObjs : (objs) ->
      for k,v of objs
        if  v.type is "image" then obj = @createSprite v.width, v.height, v.src
        else if v.type is "label" then obj = @createLabel v.font, v.color, v.align
        obj.x = v.x
        obj.y = v.y
        @addChild @getCurrentScene(), obj, v.z

    removeAllObjs : (dist) ->
      for v in dist.childNodes then @removeChild dist v

    deactive : -> @active = false

module.exports = GameSys
