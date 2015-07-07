# Module dependencies
Store = require './store'
Actions = require './actions'
Const = require './const'

# Static methods
_keyupHandler = (e) ->
  Actions.call Const.SET_LAST_PRESSED, e.keyCode

# Class definition
Keypress = class Keypress
  on: (el = document)->
    return false if @el
    @el = el
    @el.addEventListener('keyup', _keyupHandler)

  off: ->
    return false unless @el
    el.removeEventListener('keyup', _keyupHandler)
    

keypressInstance = new Keypress
module.exports = keypressInstance