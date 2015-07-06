# Module dependencies
ActionsClass = require 'arc/actions/class'
Dispatcher = require 'dispatcher'
Const = require './const'

# Actions methods
setVal = (val) ->
  return val

# Instantiate actions class
MenuActions = new ActionsClass
  dispatcher: Dispatcher

# Register actions methods
MenuActions.register Const.SET_FOCUSED, setVal
MenuActions.register Const.SET_SELECTED, setVal
MenuActions.register Const.SET_MENU_OPEN, setVal

module.exports = MenuActions