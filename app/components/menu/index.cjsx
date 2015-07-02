# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

# Child views
Item = require './components/menuitem'

# Static variables
menuItems = [
  { name: 'boot', title: "Boot Menu", size: 2 },
  { name: 'command', title: "Command Panel", size: 2 },
  { name: 'access', title: "Access Panel", size: 2 }
]

# Static methods
_itemFactory = (list) ->
  activeItem = @state.activeItem
  items = []

  isPrejacent = (idx) ->
    menuItems[idx + 1] && menuItems[idx + 1].name == activeItem

  isPostJacent = (idx) ->
    menuItems[idx - 1] && menuItems[idx - 1].name == activeItem

  isActive = (idx) ->
    menuItems[idx].name == activeItem

  for item, idx in menuItems
    if activeItem
      if isPrejacent(idx)
        menuItems[idx].size = -1
      else if isPostJacent(idx)
        menuItems[idx].size = 1
      else if isActive(idx)
        menuItems[idx].size = 0
      else
        menuItems[idx].size = 2
    else
      menuItems[idx].size = 2
    items.push <Item key={ "k-" + item.name } data={ item } onOver={ @itemEnter } onOut={ @itemLeave } />

  items

_itemEnter = (itemName)->
  @setState { activeItem: itemName }

_itemLeave = ->
  @setState { activeItem: undefined }

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
    { activeItem: undefined }

  componentWillMount: ->
    @itemEnter = _itemEnter.bind(@)
    @itemLeave = _itemLeave.bind(@)

  render: ->
    <div id="Menu" className={ @_menuClasses() } style={ @_menuStyles() }>
      <div className="wrapper" style={ @_menuStyles() }>
        <div className="menu-items" onMouseEnter={ @_mouseEnter } onMouseLeave={ @_mouseLeave }>
          { _itemFactory.call(@) }
        </div>
      </div>
    </div>

module.exports = Menu