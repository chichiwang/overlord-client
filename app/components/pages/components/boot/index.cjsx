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
  }

_focusActivation = ->
  @setState { activeInput: 1 }

_focusDeactivation = ->
  @setState { activeInput: 2 }

_focusTimer = ->
  @setState { activeInput: 3 }

_focusSave = ->
  @setState { activeInput: 4 }

_keyPressed = (e) ->
  return unless @props.active
  keyCode = e.keyCode
  # console.log 'Boot page | Key pressed >> ', keyMap[keyCode]

  _prevInput.call(@) if keyMap[keyCode] == 'up'
  _nextInput.call(@) if keyMap[keyCode] == 'down'

_nextInput = ->
  active = @state.activeInput
  @setState { activeInput: active + 1 } unless active == @numInputs

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
  }

_sendConfig = ->
  @focus.save()
  console.log '_sendConfig'

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

  _unbindKeypress: ->
    return false unless @keyListenerBound
    @keyListenerBound = false
    document.removeEventListener('keyup', @keyPressed);

  getInitialState: ->
    {
      activeInput: 1
      activation: '1234'
      deactivation: '0000'
      timer: '0300'
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

  componentWillReceiveProps: (newProps) ->
    if newProps.active
      @_bindKeypress()
    else
      @_unbindKeypress()
      @setState { activeInput: 1 }

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
