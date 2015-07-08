# @cjsx React.DOM
'use strict'

cx = require 'util/cx'
KeyStore = require 'util/keypress/store'

_classes = ->
  cx({
    button: true
    active: @props.active
  })

# Button component definition
Button = React.createClass
  displayName: 'Button'

  componentWillMount: ->
    @classes = _classes.bind(@)

  render: ->
    text = @props.text || "Button"

    <div className={ @classes() } >
      { text }
      <span className="icon-tri-right" />
      <span className="icon-tri-left" />
    </div>

module.exports = Button
