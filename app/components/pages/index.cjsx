# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

# Child views
Boot = require './components/boot'

Pages = React.createClass
  displayName: 'Pages'

  _styles: ->
    { 'max-height': @props.height }

  _classes: ->
    cx({
      'active': !@props.menuOpen
    })

  render: ->
    <div id="Pages" className={ @_classes() } style={ @_styles() }>
      <div className="wrapper">
        <Boot />
      </div>
    </div>

module.exports = Pages