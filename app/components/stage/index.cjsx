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
    to: 'code'
  }
}

menuMap = {
  boot: ['boot']
  code: ['code']
  access: ['access']
  undefined: ['detonated', 'defused']
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
    'hide': @props.socket.status != 'connected' && !@props.socket.message
  })

# Set up method _page to track current active page - call _getActivePage
_page = (socket, menu) ->
  selectedMenu = menu.selectedItem
  bomb = socket.message
  # console.log('bomb: ', bomb)
  clientUpdated = bomb?.client_updated
  initialPage = bombStateHistory[0] == undefined && !selectedMenu && !clientUpdated

  if initialPage
    currPage = _getPageFromBombState(bomb?.state)
  else if clientUpdated && socket.lastUpdated > menu.lastUpdated
    currPage = updateMap[bomb?.state].to
  else
    currPage = selectedMenu || currPage

  currPage

_activeMenu = (activePage) ->
  for menu, pageList of menuMap
    return menu if activePage in pageList

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
    bomb = @props.socket.message

    _updateBombStateHistory(bomb?.state)
    activePage = _page(@props.socket, menuState)
    activeMenu = _activeMenu(activePage)

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