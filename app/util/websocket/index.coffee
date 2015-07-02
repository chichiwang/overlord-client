# Module dependencies
Store = require './store'
Actions = require './actions'
Const = require './const'

# Static methods
_onOpen = ->
  Actions.call null, Const.SET_STATUS, Const.CONNECTED
  console.log 'Websocket >> Connected!'

_onError = (e) ->
  console.log 'Websocket >> Error: ', e

_onMessage = (msg) ->
  Actions.call null, Const.SET_MESSAGE, JSON.parse(msg.data)
  console.log 'Websocket >> Message received: ', msg

SocketClass = class SocketClass
    _server: undefined
    _socket: undefined

    _devConnect: ->
      @_devConnecting
      setTimeout ->
        Actions.call null, Const.SET_STATUS, Const.CONNECTED
      , 4000

    _devConnecting: ->
      Actions.call null, Const.SET_STATUS, Const.CONNECTING

    initialize: (server) ->
      @setServer(server)

    setServer: (server) ->
      console.log 'setServer'
      @_server = server

    connect: ->
      Actions.call null, Const.SET_STATUS, Const.CONNECTING

      @_socket = new WebSocket(@_server)
      @_socket.onopen = _onOpen
      @_socket.onerror = _onError
      @_socket.onmessage = _onMessage

    send: (msg) ->
      throw new Error "Websocket: Can not send message - not connected!" unless @_socket
      
      message =
        type: 'message'
        value: msg
        time: Date.now()

      @_socket.send(JSON.stringify(message))

    disconnect: ->
      @_socket.close()
      @_socket = undefined
      Actions.call null, Const.SET_STATUS, Const.DISCONNECTED

SocketInstance = new SocketClass
module.exports = SocketInstance