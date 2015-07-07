# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

Code = React.createClass
  displayName: 'Code'

  _classes: ->
    cx({
      code: true
      page: true
      active: @props.active
    })

  render: ->
    <div className={ @_classes() }>
      <div className="title">Command Prompt</div>
      <div className="pane">
      </div>
    </div>

module.exports = Code
