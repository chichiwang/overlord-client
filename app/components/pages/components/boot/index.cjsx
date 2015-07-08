# @cjsx React.DOM
'use strict'

cx = require 'util/cx'
KeyStore = require 'util/keypress/store'

# Child views
Input = require '../input'

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
  code = val.lastPressed
  console.log 'Boot page | Key pressed >> ', keyMap[code]

_updateActivation = (val) ->
  @setState { activation: val }

Boot = React.createClass
  displayName: 'Boot'

  getInitialState: ->
    {
      activation: '1234'
    }

  componentWillMount: ->
    @classes = _classes.bind(@)
    @updateActivation = _updateActivation.bind(@)
    @keypressed = _keypressed.bind(@)
    KeyStore.on('change', @keypressed)

  render: ->
    <div className={ @classes() }>
      <div className="title">Configuration</div>
      <div className="pane">
        <Input label="Activation Code" val={ @state.activation } onUpdate={ @updateActivation } active={ true } />
      </div>
    </div>

  componentWillUnmount: ->
    KeyStore.off('change', @keypressed)

module.exports = Boot
