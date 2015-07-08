# @cjsx React.DOM
'use strict'

cx = require 'util/cx'
KeyStore = require 'util/keypress/store'

# Child views
Input = require '../input'
Button = require '../button'

# Static variables
keyMap = {
  38: 'up'
  40: 'down'
}

# Static methods
_classes = ->
  cx({
    boot: true
    page: true
    active: @props.active
  })

_keypressed = (val) ->
  return unless @props.active
  keyCode = val.lastPressed
  active = @state.activeInput
  # console.log 'Boot page | Key pressed >> ', keyMap[keyCode]

  if keyMap[keyCode] == 'up'
    @setState { activeInput: active - 1 } unless active == 1
  if keyMap[keyCode] == 'down'
    @setState { activeInput: active + 1 } unless active == @numInputs

_updateActivation = (val) ->
  @setState { activation: val }

_updateDeactivation = (val) ->
  @setState { deactivation: val }

_updateTimer = (val) ->
  @setState { timer: val }

Boot = React.createClass
  displayName: 'Boot'
  numInputs: 4

  getInitialState: ->
    {
      activeInput: 1
      activation: '1234'
      deactivation: '0000'
      timer: '0300'
    }

  componentWillMount: ->
    @classes = _classes.bind(@)
    @updateActivation = _updateActivation.bind(@)
    @updateDeactivation = _updateDeactivation.bind(@)
    @updateTimer = _updateTimer.bind(@)

    @keypressed = _keypressed.bind(@)
    KeyStore.on('change', @keypressed)

  render: ->
    <div className={ @classes() }>
      <div className="title">Configuration</div>
      <div className="pane">
        <Input label="Activation Code" val={ @state.activation } onUpdate={ @updateActivation } active={ @state.activeInput == 1 } />
        <Input label="Deactivation Code" val={ @state.deactivation } onUpdate={ @updateDeactivation } active={ @state.activeInput == 2 } />
        <Input label="Timer(sec)" val={ @state.timer } onUpdate={ @updateTimer } active={ @state.activeInput == 3 } />
        <div className="save row">
          <Button text="SAVE" active={ @state.activeInput == 4 } />
        </div>
      </div>
    </div>

  componentWillUnmount: ->
    KeyStore.off('change', @keypressed)

module.exports = Boot
