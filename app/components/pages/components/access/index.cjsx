# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

Access = React.createClass
  displayName: 'Access'

  _classes: ->
    cx({
      access: true
      page: true
      active: @props.active
    })

  render: ->
    <div className={ @_classes() }>
      <div className="title">Access Panel</div>
      <div className="pane">
      </div>
    </div>

module.exports = Access
