# @cjsx React.DOM

Actions = require './actions'
Const = require './const'

# Child views
Item = require './components/menuitem'

# Static variables
menuItems = [
  {
    name: 'boot',
    title: "Boot Menu",
    size: 2,
    defaultState: 'boot'
    displayStates: ['boot', 'inactive'],
    switchStates: { undefined: ['boot'] },
    selected: false
  },
  {
    name: 'code',
    title: "Input Code",
    size: 2,
    defaultState: 'active, inactive'
    displayStates: ['inactive', 'active'],
    switchStates: {
                    undefined: ['inactive', 'active']
                  },
    selected: false
  },
  {
    name: 'access',
    title: "Access Panel",
    size: 2,
    defaultState: ''
    displayStates: ['inactive', 'active'],
    switchStates: {},
    selected: false
  }
]

# Static methods
_items = (enter, leave, click)->
  bombState = @props.bombState
  focusedItem = @state.focusedItem
  activeItem = @props.activeItem

  items = _displayedItems(bombState)
  items = _applySizes(items, focusedItem)
  items = _applySelected(items, activeItem)

  _generateMenuItems(items, enter, leave, click)

_displayedItems = (bombState) ->
  items = []
  for item in menuItems
    items.push(item) if bombState in item.displayStates
  items

_applySizes = (items, focusedItem) ->

  isPrejacent = (n) ->
    items[n + 1] && items[n + 1].name == focusedItem

  isPostJacent = (n) ->
    items[n - 1] && items[n - 1].name == focusedItem

  isActive = (n) ->
    items[n].name == focusedItem

  for item, idx in items
    if focusedItem && (isPrejacent(idx) || isPostJacent(idx))
      items[idx].size = 1
    else if focusedItem && isActive(idx)
      items[idx].size = 0
    else
      items[idx].size = 2

  items

_applySelected = (items, activeItem)->
  for item in items
    item.selected = if item.name == activeItem then true else false
  items

_generateMenuItems = (itemsList, enter, leave, click) ->
  items = []
  for item in itemsList
    items.push <Item key={ "k-" + item.name } data={ item } onOver={ enter } onOut={ leave } onClick={ click } />
  items


# Class definition
MenuFactory = class MenuFactory

  setContext: (ctx) ->
    @ctx = ctx

  setEnter: (itemEnterCallback) ->
    @enter = itemEnterCallback

  setLeave: (itemLeaveCallback) ->
    @leave = itemLeaveCallback

  setClick: (itemClickCallback) ->
    @click = itemClickCallback

  items: ->
    _items.call @ctx, @enter, @leave, @click

FactoryInstance = new MenuFactory
module.exports = FactoryInstance
