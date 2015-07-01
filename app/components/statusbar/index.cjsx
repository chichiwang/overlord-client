# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

StatusBar = React.createClass
  displayName: 'StatusBar'

  rootClasses: ->
    cx({
      initialized: @props.initialized
    })
  connectionClasses: ->
    cx({
      'connection-status': true
      'connected': @props.socket == 'connected'
      'connecting': @props.socket == 'connecting'
      'disconnected': @props.socket == 'disconnected'
      'error': @props.socket == 'error'
      })

  render: ->
    <div id="StatusBar" className={ @rootClasses() }>
      <div className="os">
        <span className="icon-skeletor" />
        <span className="title">Overlord Systems</span>
      </div>
      <div className={ @connectionClasses() }>
        <span className="icon-spin spinning" />
        <span className="connecting">establishing connection...</span>
        <span className="connected">connected</span>
        <span className="disconnected">disconnected</span>
        <span className="error">error connecting</span>
      </div>
    </div>

module.exports = StatusBar