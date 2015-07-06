# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

# Static methods
_mouseEnter = ->
  @props.onOver(@props.data.name)

_mouseLeave = ->
  @props.onOut()

_mouseClick = ->
  return false if @props.data.selected
  @props.onClick(@props.data.name)

_itemClassname = ->
  cx({
      'menu-item': true
      'active': @props.data.size == 0
      'adjacent': @props.data.size == 1
      'selected': @props.data.selected
    })

MenuItem = React.createClass
  displayName: 'MenuItem'

  itemClass: ->
    _itemClassname.call @

  componentWillMount: ->
    @enter = _mouseEnter.bind(@)
    @leave = _mouseLeave.bind(@)
    @click = _mouseClick.bind(@)

  render: ->
    title = @props.title || "Menu Item"
    <div className={ @itemClass() } onMouseEnter={ @enter } onMouseLeave={ @leave } onClick= { @click }>
      <div className="btn">
        <span className="arrow icon-tri-right" />
        { @props.data.title }
        <span className="arrow icon-tri-left" />
      </div>
    </div>

module.exports = MenuItem