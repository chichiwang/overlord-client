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
  Actions.call Const.set_SELECTED, itemName

# Menu view component
Menu = React.createClass
  displayName: 'Menu'
  mixins: [SyncState]
  stores: Store

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