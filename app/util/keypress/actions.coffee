# Module dependencies
ActionsClass = require 'arc/actions/class'
Dispatcher = require 'dispatcher'
Const = require './const'

# Actions methods
setVal = (val) ->
  return val

# Instantiate actions class
KeypressActions = new ActionsClass
  dispatcher: Dispatcher

# Register actions methods
KeypressActions.register Const.SET_LAST_PRESSED, setVal

module.exports = KeypressActions