# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

Status = React.createClass
  displayName: 'Status'

  classes: ->
    cx({
      'connection-status': true
      'connected': @props.socket == 'connected'
      'connecting': @props.socket == 'connecting'
      'disconnected': @props.socket == 'disconnected'
      'error': @props.socket == 'error'
      })

  render: ->
    <div className={ @classes() }>
      <span className="icon-spin spinning" />
      <span className="connecting">establishing connection...</span>
      <span className="connected">connected</span>
      <span className="disconnected">disconnected</span>
      <span className="error">error connecting</span>
    </div>

module.exports = Status