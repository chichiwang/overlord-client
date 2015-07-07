# @cjsx React.DOM
'use strict'

# Child views
Input = require '../input'

Boot = React.createClass
  displayName: 'Boot'

  render: ->
    <div className="boot page">
      <div className="title">Configuration</div>
      <div className="pane">
        <Input label="Activation Code" />
      </div>
    </div>

module.exports = Boot
