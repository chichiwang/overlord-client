# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

# Child views
Access = require './components/access'
Boot = require './components/boot'
Code = require './components/code'

Pages = React.createClass
  displayName: 'Pages'

  _styles: ->
    { 'max-height': @props.height }

  _wrapper_styles: ->
    { 'height': @props.height * 0.8 }

  _classes: ->
    cx({
      'active': !@props.menuOpen
      'boot': @props.page == 'boot'
      'code': @props.page == 'code'
      'access': @props.page == 'access'
    })

  render: ->
    <div id="Pages" className={ @_classes() } style={ @_styles() }>
      <div className="wrapper">
        <div className="page-wrapper" style={ @_wrapper_styles() }>
          <Boot active={ @props.page == 'boot' } bomb={ @props.bomb } />
          <Code active={ @props.page == 'code' } />
          <Access active={ @props.page == 'access' } />
        </div>
      </div>
    </div>

module.exports = Pages