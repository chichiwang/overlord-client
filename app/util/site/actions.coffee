# Module dependencies
ActionsClass = require 'arc/actions/class'
Dispatcher = require 'dispatcher'
Const = require './const'

# Actions methods
setDimensions = (width, height) ->
  return {
    width: width
    height: height
  }
setOrientation = (orientation) ->
  return orientation

setScreen = (val) ->
  return val

# Instantiate actions class
SiteActions = new ActionsClass
  dispatcher: Dispatcher

# Register actions methods
SiteActions.register Const.SET_DIMENSIONS, setDimensions
SiteActions.register Const.SET_ORIENTATION, setOrientation
SiteActions.register Const.SET_SCREEN, setScreen

module.exports = SiteActions