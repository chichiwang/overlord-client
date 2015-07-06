# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

# Child views
Item = require './components/menuitem'

# Static variables
menuItems = [
  { name: 'boot', title: "Boot Menu", size: 2, validStates: ['boot', 'inactive'] },
  { name: 'command', title: "Command Panel", size: 2, validStates: ['inactive', 'active'] },
  { name: 'access', title: "Access Panel", size: 2, validStates: ['inactive', 'active'] }
]

# Static methods
_itemFactory = (list) ->
  activeItem = @state.activeItem
  validItems = _validItems(@props.state)
  console.log '_itemFactory', @props.state, validItems
  items = []

  isPrejacent = (idx) ->
    validItems[idx + 1] && validItems[idx + 1].name == activeItem

  isPostJacent = (idx) ->
    validItems[idx - 1] && validItems[idx - 1].name == activeItem

  isActive = (idx) ->
    validItems[idx].name == activeItem

  for item, idx in validItems
    if activeItem
      if isPrejacent(idx)
        validItems[idx].size = -1
      else if isPostJacent(idx)
        validItems[idx].size = 1
      else if isActive(idx)
        validItems[idx].size = 0
      else
        validItems[idx].size = 2
    else
      validItems[idx].size = 2
    items.push <Item key={ "k-" + item.name } data={ item } onOver={ @itemEnter } onOut={ @itemLeave } />

  items

_itemEnter = (itemName) ->
  @setState { activeItem: itemName }

_itemLeave = ->
  @setState { activeItem: undefined }

_validItems = (state) ->
  items = []
  for item in menuItems
    items.push(item) if state && state in item.validStates
  items

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
    console.log 'Menu Render: ', @props.state
    <div id="Menu" className={ @_menuClasses() } style={ @_menuStyles() }>
      <div className="wrapper" style={ @_menuStyles() }>
        <div className="menu-items" onMouseEnter={ @_mouseEnter } onMouseLeave={ @_mouseLeave }>
          { _itemFactory.call(@) }
        </div>
      </div>
    </div>

module.exports = Menu