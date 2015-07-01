# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

# Static methods
_mouseEnter = ->
  @props.onOver(@props.data.name)

_mouseLeave = ->
  @props.onOut()
  
MenuItem = React.createClass
  displayName: 'MenuItem'

  _itemClassname: ->
    cx({
      'menu-item': true
      'active': @props.data.size == 0
      'pre1': @props.data.size == -1
      'post1': @props.data.size == 1
    })

  componentWillMount: ->
    @enter = _mouseEnter.bind(@)
    @leave = _mouseLeave.bind(@)

  render: ->
    title = @props.title || "Menu Item"
    <div className={ @_itemClassname() } onMouseEnter={ @enter } onMouseLeave={ @leave }>
      <div className="btn">{ @props.data.title }</div>
    </div>

module.exports = MenuItem