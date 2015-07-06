# @cjsx React.DOM
'use strict'

cx = require 'util/cx'
Factory = require './menuFactory'

# Static methods
_itemEnter = (itemName) ->
  @setState { focusedItem: itemName }

_itemLeave = ->
  @setState { focusedItem: undefined }

_itemClick = (itemName)->
  @setState { selectedItem: itemName }

# Menu view component
Menu = React.createClass
  displayName: 'Menu'

  _mouseEnter: ->
    @props.onOver()
  _mouseLeave: ->
    @props.onOut()

  _menuClasses: ->
    cx({
      active: @props.isOpen
    })

  _menuStyles: ->
    { 'max-height': @props.height }

  getInitialState: ->
    {
      focusedItem: undefined,
      selectedItem: undefined
    }

  componentWillMount: ->
    Factory.setContext(@)
    Factory.setEnter(_itemEnter.bind(@))
    Factory.setLeave(_itemLeave.bind(@))
    Factory.setClick(_itemClick.bind(@))

  render: ->
    # console.log 'Menu Render: ', @props.bombState
    <div id="Menu" className={ @_menuClasses() } style={ @_menuStyles() }>
      <div className="wrapper" style={ @_menuStyles() }>
        <div className="menu-items" onMouseEnter={ @_mouseEnter } onMouseLeave={ @_mouseLeave }>
          { Factory.items() }
        </div>
      </div>
    </div>

module.exports = Menu