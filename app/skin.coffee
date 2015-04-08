class Skin
  constructor : (@_sys)->

  init : (res)-> @_sys.allocateObjs res

module.exports = Skin
