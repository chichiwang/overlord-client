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
pageMap = {
  boot: ['boot']
  code: ['inactive', 'active']
  detonated: ['detonated']
  defused: ['defused']
}

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
  console.log 'Stage >> bombState: ', bombState
  console.log 'Stage >> selectedMenu', selectedMenu
  console.log 'Stage >> bombStateHistory', bombStateHistory

  if bombStateHistory[0] == undefined
    for key, page of pageMap
      return key if bombState in page
  else
    bombState

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
        <Pages height={ stageHeight } menuOpen={ menuState.menuOpen } page={ activeItem } bomb={ @props.bomb } />
      </div>
    </div>

  componentDidMount: ->
    stageHeight = _getStageHeight()

  componentDidUpdate: ->
    # console.log 'Stage', Menu
    stageHeight = _getStageHeight()

module.exports = Stage