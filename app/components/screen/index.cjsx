# @cjsx React.DOM
'use strict'

Screen = React.createClass
  displayName: 'Screen'

  styles: ->
    {
      width: @props.width,
      height: @props.height
    }

  render: ->
    <div id="Terminal-Screen" style={@styles()}>
      <div className="green-burn" />
      <div className="scanline" />
    </div>

module.exports = Screen