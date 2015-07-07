# @cjsx React.DOM
'use strict'

Input = React.createClass
  displayName: 'Input'

  render: ->
    <div className="input row">
      <div className="label">
        { @props.label }
      </div>
      <div className="input-area">
        <div className="key-input">
          <span className="key k0">1</span>
          <span className="key k1">2</span>
          <span className="key k2">3</span>
          <span className="key k3">4</span>
          <span className="icon-tri-right" />
          <span className="icon-tri-left" />
          <span className="icon-tri-down" />
          <span className="icon-tri-up" />
        </div>
      </div>
    </div>

module.exports = Input
