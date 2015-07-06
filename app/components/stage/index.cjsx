# @cjsx React.DOM
'use strict'

MenuStore = require 'components/menu/store'

cx = require 'util/cx'
SyncState = require 'util/mixins/syncstate'

# Child views
Menu = require 'components/menu'
Console = require 'components/console'

# Static variables
stageHeight = 0

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

# Stage view-component
Stage = React.createClass
  displayName: 'Stage'
  mixins: [SyncState]
  stores:
    menu: MenuStore

  render: ->
    menuState = @state.menu
    bombState = @props.bomb.state if @props.bomb
    # console.log 'Stage: ', bombState

    <div id="Stage" className={ _stageStyles.call(@) }>
      <div className={ _wrapperStyles.call(@) }>
        <Menu height={ stageHeight } bombState={ bombState } />
        <Console height={ stageHeight } menuOpen={ menuState.menuOpen } />
      </div>
    </div>

  componentDidMount: ->
    stageHeight = _getStageHeight()

  componentDidUpdate: ->
    # console.log 'Stage', Menu
    stageHeight = _getStageHeight()

module.exports = Stage