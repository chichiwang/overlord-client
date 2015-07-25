# @cjsx React.DOM
'use strict'

MenuStore = require 'components/menu/store'

cx = require 'util/cx'
SyncState = require 'util/mixins/syncstate'

# Child views
Menu = require 'components/menu'
Pages = require 'components/pages'

# Static variables
currPage = undefined
stageHeight = 0
bombStateHistory = [undefined]
clientUpdated = undefined

pageMap = {
  boot: ['boot']
  code: ['inactive', 'active']
  detonated: ['detonated']
  defused: ['defused']
}

updateMap = {
  inactive: {
    from: 'boot'
    to: 'code'
  }
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

# Set up method _page to track current active page - call _getActivePage
_page = (bomb, selectedMenu) ->
  currPage = _getActivePage(bomb, selectedMenu)
  currPage

_getActivePage = (bomb, selectedMenu) ->
  # console.log 'Stage >> bomb: ', bomb
  # console.log 'Stage >> selectedMenu', selectedMenu
  # console.log 'Stage >> bombStateHistory', bombStateHistory

  clientUpdated = bomb && bomb.client_updated
  initialPage = bombStateHistory[0] == undefined && !selectedMenu && !clientUpdated

  if initialPage
    page = _getPageFromBombState(bomb?.state)
  else if clientUpdated
    page = updateMap[bomb?.state].to
    # clientUpdated = undefined
  else
    page = selectedMenu || updateMap[bomb.state].from

  page

_getPageFromBombState = (bombState) ->
  for key, page of pageMap
    return key if bombState in page

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
    bomb = @props.bomb

    _updateBombStateHistory(bomb?.state)
    activePage = _page(bomb, menuState.selectedItem)
    activeMenu = menuState.selectedItem || activePage

    <div id="Stage" className={ _stageStyles.call(@) }>
      <div className={ _wrapperStyles.call(@) }>
        <Menu height={ stageHeight } bombState={ bomb?.state } activeItem={ activeMenu } />
        <Pages height={ stageHeight } menuOpen={ menuState.menuOpen } page={ activePage } bomb={ bomb } />
      </div>
    </div>

  componentDidMount: ->
    stageHeight = _getStageHeight()

  componentDidUpdate: ->
    # console.log 'Stage', Menu
    stageHeight = _getStageHeight()

module.exports = Stage