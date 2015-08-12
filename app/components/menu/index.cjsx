# @cjsx React.DOM
'use strict'

Store = require './store'
Actions = require './actions'
Const = require './const'

cx = require 'util/cx'
SyncState = require 'util/mixins/syncstate'
Factory = require './menuFactory'

# Static methods
_itemEnter = (itemName) ->
  Actions.call Const.SET_FOCUSED, itemName

_itemLeave = ->
  Actions.call Const.SET_FOCUSED, undefined

_itemClick = (itemName)->
  Actions.call Const.SET_SELECTED, itemName

_menuEnter = ->
  Actions.call Const.SET_MENU_OPEN, true

_menuLeave = ->
  Actions.call Const.SET_MENU_OPEN, false

# Menu view component
Menu = React.createClass
  displayName: 'Menu'
  mixins: [SyncState]
  stores: Store

  _menuClasses: ->
    cx({
      active: @state.menuOpen
    })

  _menuStyles: ->
    { 'max-height': @props.height }

  componentWillMount: ->
    Factory.setContext(@)
    Factory.setEnter(@itemEnter)
    Factory.setLeave(@itemLeave)
    Factory.setClick(@itemClick)

  itemClick: (itemName) ->
    _itemClick.call(@, itemName)

  itemEnter: (itemName) ->
    _itemEnter.call(@, itemName)

  itemLeave: ->
    _itemLeave.call(@)

  render: ->
    <div id="Menu" className={ @_menuClasses() } style={ @_menuStyles() }>
      <div className="wrapper" style={ @_menuStyles() }>
        <div className="menu-items" onMouseEnter={ _menuEnter } onMouseLeave={ _menuLeave }>
          { Factory.items() }
        </div>
      </div>
    </div>

module.exports = Menu