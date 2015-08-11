'use strict'
# [React Mixin] Page Navigation
# Listen for keypresses
# Utility functions for page nagivation functionality

# Static variables
keyMap = {
  38: 'up'
  40: 'down'
  block: {
    8: 'backspace'
    9: 'tab'
  }
}

# Static methods
_bindKeypress = ->
  return false if @keyListenerBound
  @keyListenerBound = true
  document.addEventListener('keyup', @keyPressed);
  document.addEventListener('keydown', @blockKey);

_blockKey = (e) ->
  return unless @props.active
  keyCode = e.keyCode

  @nextInput() if keyMap.block[keyCode] == 'tab'
  e.preventDefault() if keyMap.block[keyCode]

_keyPressed = (e) ->
  return unless @props.active
  keyCode = e.keyCode

  _prevInput.call(@) if keyMap[keyCode] == 'up'
  _nextInput.call(@) if keyMap[keyCode] == 'down'

_nextInput = ->
  active = @state.activeInput
  @setState { activeInput: active + 1 } unless active == @numInputs

_prevInput = ->
  active = @state.activeInput
  @setState { activeInput: active - 1 } unless active == 1

_unbindKeypress = ->
  return false unless @keyListenerBound
  @keyListenerBound = false
  document.removeEventListener('keyup', @keyPressed);
  document.removeEventListener('keydown', @blockKey); 

# Export a set of utility functions
module.exports =
  bindKeypress: ->
    _bindKeypress.call(@)
  blockKey: (e)->
    _blockKey.call(@, e)
  componentWillReceiveProps: (newProps) ->
    if newProps.active
      @bindKeypress()
    else
      @unbindKeypress()
  keyPressed: (e)->
    _keyPressed.call(@, e)
  nextInput: ->
    _nextInput.call(@)
  prevInput: ->
    _prevInput.call(@)
  unbindKeypress: ->
    _unbindKeypress.call(@)