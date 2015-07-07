# @cjsx React.DOM
'use strict'

MenuStore = require 'components/menu/store'

cx = require 'util/cx'
SyncState = require 'util/mixins/syncstate'

# Child views
Menu = require 'components/menu'
Pages = require 'components/pages'

# Static variables
stageHeight = 0
bombStateHistory = [undefined]
switchActive = { boot: [undefined] }

# Static methods
_getStageHeight = ->
  document.querySelector('#Stage').getBoundingClientRect().height

_wrapperStyles = ->
  cx({
    'stage-wrapper': true
    'menu-active': @state.menu.menuOpen
  })

_stageStyles = ->
  cx({
    'hide': @props.socket != 'connected' && !@props.bomb
  })

_getActiveMenuItem = (bombState, selectedMenu) ->
  if bombState of switchActive && bombStateHistory[0] in switchActive[bombState]
    bombState
  else
    selectedMenu

_getActiveConsole = ->
  # ...

_updateBombStateHistory = (bombState) ->
  if bombStateHistory.length == 1
    bombStateHistory.push(bombState)
  return if bombStateHistory[1] == bombState
  bombStateHistory[0] = bombStateHistory[1]
  bombStateHistory[1] = bombState

# Stage view-component
Stage = React.createClass
  displayName: 'Stage'
  mixins: [SyncState]
  stores:
    menu: MenuStore

  render: ->
    menuState = @state.menu
    bombState = @props.bomb.state if @props.bomb

    _updateBombStateHistory(bombState)
    activeItem = _getActiveMenuItem(bombState, menuState.selectedItem)

    <div id="Stage" className={ _stageStyles.call(@) }>
      <div className={ _wrapperStyles.call(@) }>
        <Menu height={ stageHeight } bombState={ bombState } activeItem={ activeItem } />
        <Pages height={ stageHeight } menuOpen={ menuState.menuOpen } />
      </div>
    </div>

  componentDidMount: ->
    stageHeight = _getStageHeight()

  componentDidUpdate: ->
    # console.log 'Stage', Menu
    stageHeight = _getStageHeight()

module.exports = Stage