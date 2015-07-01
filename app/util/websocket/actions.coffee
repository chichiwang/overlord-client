# Module dependencies
ActionsClass = require 'arc/actions/class'
Dispatcher = require 'dispatcher'
Const = require './const'

# Actions methods
setStatus = (val) ->
  return val
setMessage = (val) ->
  return val

# Instantiate actions class
SocketActions = new ActionsClass
  dispatcher: Dispatcher

# Register actions methods
SocketActions.register Const.SET_STATUS, setStatus
SocketActions.register Const.SET_MESSAGE, setMessage

module.exports = SocketActions