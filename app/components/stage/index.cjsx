# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

# Child views
Menu = require 'components/menu'
Console = require 'components/console'

# Static variables
stageHeight = 0
menuIsOpen = false

# Static methods
_getStageHeight = ->
  document.querySelector('#Stage').getBoundingClientRect().height

_wrapperStyles = ->
  cx({
    'stage-wrapper': true
    'menu-active': @state.menuIsOpen
  })

_menuOver = ->
  @setState { menuIsOpen: true }

_menuOut = ->
  @setState { menuIsOpen: false }

# Stage view-component
Stage = React.createClass
  displayName: 'Stage'

  getInitialState: ->
    { menuIsOpen: false }

  componentWillMount: ->
    @over = _menuOver.bind(@)
    @out = _menuOut.bind(@)

  render: ->
    <div id="Stage">
      <div className={ _wrapperStyles.call(@) }>
        <Menu height={ stageHeight } onOver={ @over } onOut={ @out } isOpen={ @state.menuIsOpen } />
        <Console height={ stageHeight } menuIsOpen={ @state.menuIsOpen } />
      </div>
    </div>

  componentDidMount: ->
    stageHeight = _getStageHeight()

  componentDidUpdate: ->
    stageHeight = _getStageHeight()

  componentWillUnmount: ->


module.exports = Stage