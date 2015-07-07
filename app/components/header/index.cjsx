# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

# Child view
Status = require './components/status'

Header = React.createClass
  displayName: 'Header'

  classes: ->
    cx({
      initialized: @props.initialized
    })

  render: ->
    <div id="Header" className={ @classes() }>
      <div className="os">
        <span className="icon-skeletor" />
        <span className="title">Overlord Systems</span>
      </div>
      <Status socket={ @props.socket } />
    </div>

module.exports = Header