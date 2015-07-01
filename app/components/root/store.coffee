'use strict'

# Module dependencies
StoreClass = require 'arc/store/class'
Dispatcher = require 'dispatcher'
Const = require './const'

# Dispatch handlers
setInitialized = (val) ->
  @value.initialized = val

# Instantiate store class
RootStore = new StoreClass
  dispatcher: Dispatcher
  initial:
    initialized: false

# Register handlers to store
RootStore.registerAction Const.SET_INITIALIZED, setInitialized

module.exports = RootStore