# @cjsx React.DOM
'use strict'

cx = require 'util/cx'
ws = require 'util/websocket'

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
_activationProps = ->
  {
    label: "Activation Code"
    val: @state.activation
    onUpdate: @updateActivation
    onNext: @nextInput
    onPrev: @prevInput
    onClick: @focus.activation
    active: @state.activeInput == 1
    invalid: @state.activation == @state.deactivation
  }

_classes = ->
  cx({
    boot: true
    page: true
    active: @props.active
  })

_deactivationProps = ->
  {
    label: "Deactivation Code"
    val: @state.deactivation
    onUpdate: @updateDeactivation
    onNext: @nextInput
    onPrev: @prevInput
    onClick: @focus.deactivation
    active: @state.activeInput == 2
    invalid: @state.activation == @state.deactivation
  }

_focusActivation = ->
  @setState { activeInput: 1 }

_focusDeactivation = ->
  @setState { activeInput: 2 }

_focusTimer = ->
  @setState { activeInput: 3 }

_focusSave = ->
  @setState { activeInput: 4 }

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

_padFourDigits = (num) ->
  ("0000" + num).slice(-4)

_prevInput = ->
  active = @state.activeInput
  @setState { activeInput: active - 1 } unless active == 1

_saveProps = ->
  {
    text: "SAVE"
    active: @state.activeInput == 4
    onNext: @nextInput
    onPrev: @prevInput
    onClick: @sendConfig
    locked: @state.activation == @state.deactivation
    lockedText: "Codes can not be the same!"
  }

_sendConfig = ->
  @focus.save()
  ws.sendConfigure(@state.activation, @state.deactivation, @state.timer)
  # console.log '_sendConfig', {
  #   activation: @state.activation
  #   deactivation: @state.deactivation
  #   timer: @state.timer
  # }

_timerProps = ->
  {
    label: "Timer Duration(sec)"
    val: @state.timer
    onUpdate: @updateTimer
    onNext: @nextInput
    onPrev: @prevInput
    onClick: @focus.timer
    active: @state.activeInput == 3
  }

_updateActivation = (val) ->
  @setState { activation: val }

_updateDeactivation = (val) ->
  @setState { deactivation: val }

_updateTimer = (val) ->
  @setState { timer: val }

# Boot component definition
Boot = React.createClass
  displayName: 'Boot'
  numInputs: 4

  focus: undefined

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

  _initState: (props)->
    return false if @stateInit
    @stateInit = true
    @setState {
      activation: props.bomb.activation_code
      deactivation: props.bomb.deactivation_code
      timer: _padFourDigits(props.bomb.timer_duration)
    }

  _resetState: ->
    return false unless @stateInit
    @stateInit = false
    @setState {
      activeInput: 1
      activation: undefined
      deactivation: undefined
      timer: undefined
    }

  getInitialState: ->
    {
      activeInput: 1
      activation: undefined
      deactivation: undefined
      timer: undefined
    }

  componentWillMount: ->
    @updateActivation = _updateActivation.bind(@)
    @updateDeactivation = _updateDeactivation.bind(@)
    @updateTimer = _updateTimer.bind(@)
    @sendConfig = _sendConfig.bind(@)

    @focus = {}
    @focus.activation = _focusActivation.bind(@)
    @focus.deactivation = _focusDeactivation.bind(@)
    @focus.timer = _focusTimer.bind(@)
    @focus.save = _focusSave.bind(@)

    @nextInput = _nextInput.bind(@)
    @prevInput = _prevInput.bind(@)

    @keyPressed = _keyPressed.bind(@)
    @keyBlock = _keyBlock.bind(@)

  componentWillReceiveProps: (newProps) ->
    if newProps.active
      @_bindKeypress()
      @_initState(newProps) if newProps.bomb
    else
      @_unbindKeypress()
      @_resetState()

  render: ->
    <div className={ _classes.call(@) }>
      <div className="title">Configuration</div>
      <div className="pane">
        <Input {..._activationProps.call(@)} />
        <Input {..._deactivationProps.call(@)} />
        <Input {..._timerProps.call(@)} />
        <div className="save row">
          <Button {..._saveProps.call(@)} />
        </div>
      </div>
    </div>

module.exports = Boot
