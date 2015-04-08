EventObserver = require './eventObserver'
FallObj = require './fallObj'

class MeasureNodes extends FallObj

  constructor : (@_sys, @_timer)->
    @_index = 0
    @_notifier = new EventObserver()
    @_nodes = []
    @_genTime = []

  #
  # create and pool nodes
  #
  # @param  res   - resouce data
  # @param  bpms  - BPM change list
  # @param  nodes - node parameter
  # @return node generation time Array
  #
  init : (res, bpms, nodes)->
    time = 0
    @_nodes.length = 0
    @_genTime.length = 0

    for v, i in nodes
      node = @_sys.createSprite res.nodeImage.width, res.nodeImage.height, res.nodeImage.src
      node.timing = v.timing
      node.x = res.nodeImage.x
      node.y = res.nodeImage.y
      #node.measure = i

      @_appendFallParams node, bpms, time, res.fallDist
      @_genTime.push time
      time = @_getGenTime node, res.fallDist
      @_nodes.push node
    @_genTime

  #
  # start node update
  #
  start : -> @_scheduleId = @_sys.setScheduler @_add

  #
  # stop node update
  #
  stop : -> @_sys.clearScheduler @_scheduleId

  #
  # add event listener
  #
  # @param name - event name
  # @param listener - listener
  #
  addListener: (name, listner)->
    @_notifier.on name, listner

  #
  # get time when node y coordinate will be 0px
  # to generate next node
  #
  _getGenTime : (obj, fallDist)->
    for v, i in obj.dstY when v > 0
      return ~~(obj.bpm.timing[i] - (v / @_calcSpeed(obj.bpm.val[i], fallDist)))
    return 0

  #
  # add note to game scene
  # @attention - _add called by window
  #
  _add : =>
    return unless @_genTime[@_index]?
    return unless @_genTime[@_index] <= @_timer.get()
    @_sys.addChild @_sys.getCurrentScene(), @_nodes[@_index]
    @_sys.setScheduler @_update.bind(@, @_nodes[@_index]), @_nodes[@_index]
    @_index++

  #
  # update node by FPS
  #
  _update : (node)->
    time = @_timer.get()
    while time > node.bpm.timing[node.index]
      if node.index < node.bpm.timing.length - 1 then node.index++
      else break
    diffTime = node.bpm.timing[node.index] - time
    diffDist = diffTime * node.speed[node.index]
    node.y = node.dstY[node.index] - diffDist

    if node.y > node.dstY[node.index]
      @_sys.removeChild @_sys.getCurrentScene(), node
      @_notifier.trigger 'remove', time

module.exports = MeasureNodes
