# Module dependencies
ActionsClass = require 'arc/actions/class'
Dispatcher = require 'dispatcher'
Const = require './const'

# Actions methods
setInitialized = (val) ->
  return val

# Instantiate actions class
RootActions = new ActionsClass
  dispatcher: Dispatcher

# Register actions methods
RootActions.register Const.SET_INITIALIZED, setInitialized

module.exports = RootActions