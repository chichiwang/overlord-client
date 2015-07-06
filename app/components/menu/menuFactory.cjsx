# @cjsx React.DOM

# Child views
Item = require './components/menuitem'

# Static variables
bombStateHistory = [undefined]
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
    name: 'command',
    title: "Command Panel",
    size: 2,
    defaultState: 'active, inactive'
    displayStates: ['inactive', 'active'],
    switchStates: {
                    boot: ['inactive'],
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
  selectedItem = @state.selectedItem

  _updateBombStateHistory(bombState)

  items = _displayedItems(bombState)
  items = _applySizes(items, focusedItem)
  items = _applySelected(items, selectedItem)
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

_applySelected = (items, selectedItem)->
  prevBombState = bombStateHistory[0]
  currBombState = bombStateHistory[1]

  for item in items
    item.selected = if item.name == selectedItem then true else false
    if item.switchStates[prevBombState]
      item.selected = true if currBombState in item.switchStates[prevBombState]
  items

_updateBombStateHistory = (bombState) ->
  if bombStateHistory.length == 1
    bombStateHistory.push(bombState)
  return if bombStateHistory[1] == bombState
  bombStateHistory[0] = bombStateHistory[1]
  bombStateHistory[1] = bombState

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
