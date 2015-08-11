# @cjsx React.DOM
'use strict'

cx = require 'util/cx'
ws = require 'util/websocket'

PageNavigation = require 'util/mixins/pagenavigation'

# Child views
Input = require '../input'
Button = require '../button'

# Static variables
currState = 'inactive'

# Static methods
_activationProps = ->
  {
    label: "Activation Code"
    val: @state.activation
    onUpdate: @updateActivation
    onNext: @nextInput
    onPrev: @prevInput
    onClick: @focusActivation
    active: @props.active && @state.activeInput == 1
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
    onClick: @focusDeactivation
    active: @props.active && @state.activeInput == 2
    invalid: @state.activation == @state.deactivation
  }

_padFourDigits = (num) ->
  ("0000" + num).slice(-4)

_saveProps = ->
  {
    text: "SAVE"
    active: @props.active && @state.activeInput == 4
    onNext: @nextInput
    onPrev: @prevInput
    onClick: @sendConfig
    locked: @state.activation == @state.deactivation
    lockedText: "Codes can not be the same!"
  }

_sendConfig = ->
  @focusSave()
  ws.sendConfigure(@state.activation, @state.deactivation, @state.timer)

_setActiveInput = (val) ->
  @setState { activeInput: val }

_timerProps = ->
  {
    label: "Timer Duration(sec)"
    val: @state.timer
    onUpdate: @updateTimer
    onNext: @nextInput
    onPrev: @prevInput
    onClick: @focusTimer
    active: @props.active && @state.activeInput == 3
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
  mixins: [PageNavigation]
  numInputs: 4

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

  focusActivation: ->
    _setActiveInput.call(@, 1)

  focusDeactivation: ->
    _setActiveInput.call(@, 2)

  focusTimer: ->
    _setActiveInput.call(@, 3)

  focusSave: ->
    _setActiveInput.call(@, 4)

  getInitialState: ->
    {
      activeInput: 1
      activation: undefined
      deactivation: undefined
      timer: undefined
    }

  componentWillReceiveProps: (newProps) ->
    if newProps.active && newProps.bomb && currState == 'inactive'
      @_resetState()
      @_initState(newProps)
      currState = 'active'
    else if !newProps.active
      currState = 'inactive'

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

  sendConfig: ->
    _sendConfig.call(@)

  updateActivation: (val) ->
    _updateActivation.call(@, val)

  updateDeactivation: (val) ->
    _updateDeactivation.call(@, val)

  updateTimer: (val) ->
    _updateTimer.call(@, val)

module.exports = Boot
