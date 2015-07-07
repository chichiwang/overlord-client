'use strict'

# Module dependencies
StoreClass = require 'arc/store/class'
Dispatcher = require 'dispatcher'
Const = require './const'

# Dispatch handlers
setLastPressed = (val) ->
  @value.lastPressed = val
  @value.numKeysPressed += 1

# Instantiate store class
KeypressStore = new StoreClass
  dispatcher: Dispatcher
  initial:
    lastPressed: undefined
    numKeysPressed: 0

# Register handlers to store
KeypressStore.registerAction Const.SET_LAST_PRESSED, setLastPressed

module.exports = KeypressStore