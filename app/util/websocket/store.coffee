'use strict'

# Module dependencies
StoreClass = require 'arc/store/class'
Dispatcher = require 'dispatcher'
Const = require './const'

# Dispatch handlers
setStatus = (val) ->
  @value.status = val
setMessage = (val) ->
  @value.message = val
  @value.lastUpdated = new Date()

# Instantiate store class
SocketStore = new StoreClass
  dispatcher: Dispatcher
  initial:
    status: Const.INITIAL
    message: undefined
    lastUpdated: new Date()

# Register handlers to store
SocketStore.registerAction Const.SET_STATUS, setStatus
SocketStore.registerAction Const.SET_MESSAGE, setMessage

module.exports = SocketStore