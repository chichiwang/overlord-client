# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

Page = React.createClass
  displayName: 'Page'

  _consoleStyles: ->
    { 'max-height': @props.height }

  _consoleClasses: ->
    cx({
      'active': !@props.menuOpen
    })

  render: ->
    <div id="Page" className={ @_consoleClasses() } style={ @_consoleStyles() }>
      <div className="wrapper">
        <div className="pages">
          <p>Page</p>
        </div>
      </div>
    </div>

module.exports = Page