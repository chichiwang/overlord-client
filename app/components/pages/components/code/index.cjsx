# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

# Child views
Input = require '../input'
Button = require '../button'

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
_keyBlock = (e) ->
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

Code = React.createClass
  displayName: 'Code'
  numInputs: 2

  _bindKeypress: ->
    return false if @keyListenerBound
    @keyListenerBound = true
    document.addEventListener('keyup', @keyPressed);
    document.addEventListener('keydown', @keyBlock);

  _unbindKeypress: ->
    return false unless @keyListenerBound
    @keyListenerBound = false
    document.removeEventListener('keyup', @keyPressed);
    document.removeEventListener('keydown', @keyBlock);

  _classes: ->
    cx({
      code: true
      page: true
      active: @props.active
    })

  getInitialState: ->
    {
      activeInput: 1
      currentCode: "0000"
    }

  componentWillMount: ->
    @nextInput = _nextInput.bind(@)
    @prevInput = _prevInput.bind(@)

    @keyPressed = _keyPressed.bind(@)
    @keyBlock = _keyBlock.bind(@)

  componentWillReceiveProps: (newProps) ->
    if newProps.active
      @_bindKeypress()
    else
      @_unbindKeypress()

  render: ->
    <div className={ @_classes() }>
      <div className="title">Command Prompt</div>
      <div className="pane">
        <Input label="Input Code" active={ @props.active && @state.activeInput == 1 } val={ @state.currentCode } onNext={ @nextInput } onPrev={ @prevInput } />
        <div className="save row">
          <Button text="Submit" active={ @props.active && @state.activeInput ==2 } />
        </div>
      </div>
    </div>

module.exports = Code
