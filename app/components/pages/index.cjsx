# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

Pages = React.createClass
  displayName: 'Pages'

  _consoleStyles: ->
    { 'max-height': @props.height }

  _consoleClasses: ->
    cx({
      'active': !@props.menuOpen
    })

  render: ->
    <div id="Pages" className={ @_consoleClasses() } style={ @_consoleStyles() }>
      <div className="wrapper">
        <div className="page">
          <p>Page</p>
        </div>
      </div>
    </div>

module.exports = Pages