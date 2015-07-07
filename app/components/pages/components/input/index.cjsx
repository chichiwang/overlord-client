# @cjsx React.DOM
'use strict'

KeyStore = require 'util/keypress/store'

# Static methods
_keyPressed = (val) ->
  return unless @props.active
  console.log 'Input | Key pressed >> ', val.lastPressed

Input = React.createClass
  displayName: 'Input'

  componentWillMount: ->
    @keypressHandler = _keyPressed.bind(@)
    KeyStore.on('change', @keypressHandler)

  render: ->
    <div className="input row">
      <div className="label">
        { @props.label }
      </div>
      <div className="input-area">
        <div className="key-input">
          <span className="key k0">1</span>
          <span className="key k1">2</span>
          <span className="key k2">3</span>
          <span className="key k3">4</span>
          <span className="icon-tri-right" />
          <span className="icon-tri-left" />
          <span className="icon-tri-down" />
          <span className="icon-tri-up" />
        </div>
      </div>
    </div>

  componentWillUnmount: ->
    Keystore.off('change', @keypressHandler)

module.exports = Input
