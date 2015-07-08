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
_keypressed = (val) ->
  return unless @props.active
  code = val.lastPressed
  console.log 'Boot page | Key pressed >> ', keyMap[code]

Boot = React.createClass
  displayName: 'Boot'

  _classes: ->
    cx({
      boot: true
      page: true
      active: @props.active
    })

  componentWillMount: ->
    @keypressed = _keypressed.bind(@)
    KeyStore.on('change', @keypressed)

  render: ->
    <div className={ @_classes() }>
      <div className="title">Configuration</div>
      <div className="pane">
        <Input label="Activation Code" val="1234" active={ true } />
      </div>
    </div>

  componentWillUnmount: ->
    KeyStore.off('change', @keypressed)

module.exports = Boot
