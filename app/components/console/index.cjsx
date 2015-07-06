# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

Console = React.createClass
  displayName: 'Console'

  _consoleStyles: ->
    { 'max-height': @props.height }

  _consoleClasses: ->
    cx({
      'active': !@props.menuOpen
    })

  render: ->
    <div id="Console" className={ @_consoleClasses() } style={ @_consoleStyles() }>
      <div className="wrapper">
        <div className="console-screens">
          <p>Console Page</p>
        </div>
      </div>
    </div>

module.exports = Console