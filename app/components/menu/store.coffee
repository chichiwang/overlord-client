'use strict'

# Module dependencies
StoreClass = require 'arc/store/class'
Dispatcher = require 'dispatcher'
Const = require './const'

# Dispatch handlers
setFocused = (val) ->
  @value.focusedItem = val
setSelected = (val) ->
  @value.selectedItem = val
  @value.lastUpdated = new Date()
setMenuOpen = (val) ->
  @value.menuOpen = val

# Instantiate store class
MenuStore = new StoreClass
  dispatcher: Dispatcher
  initial:
    focusedItem: undefined
    selectedItem: undefined
    lastUpdated: new Date()
    menuOpen: false

# Register handlers to store
MenuStore.registerAction Const.SET_FOCUSED, setFocused
MenuStore.registerAction Const.SET_SELECTED, setSelected
MenuStore.registerAction Const.SET_MENU_OPEN, setMenuOpen

module.exports = MenuStore