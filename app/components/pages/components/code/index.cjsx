# @cjsx React.DOM
'use strict'

cx = require 'util/cx'
PageNavigation = require 'util/mixins/pagenavigation'

# Child views
Input = require '../input'
Button = require '../button'

# Static methods
_inputCodeProps = ->
  {
    label: "Input Code"
    active: @props.active && @state.activeInput == 1
    val: @state.currentCode
    onNext: @nextInput
    onPrev: @prevInput
    onUpdate: @updateCode
  }

_sendCode = ->
  console.log 'Send code: ', @state.currentCode
  # Reset code input
  # ws.sendCode(@state.currentCode)

_updateCode = (val) ->
  @setState { currentCode: val }

# Code component definition
Code = React.createClass
  displayName: 'Code'
  mixins: [PageNavigation]
  numInputs: 2

  _classes: ->
    cx({
      code: true
      page: true
      active: @props.active
    })

  getInitialState: ->
    {
      activeInput: 1
      currentCode: "0000"
    }

  render: ->
    <div className={ @_classes() }>
      <div className="title">Command Prompt</div>
      <div className="pane">
        <Input {..._inputCodeProps.call(@)} />
        <div className="save row">
          <Button text="Submit" active={ @props.active && @state.activeInput ==2 } onClick={ @sendCode } />
        </div>
      </div>
    </div>

  sendCode: ->
    _sendCode.call(@)

  updateCode: (val) ->
    _updateCode.call(@, val)

module.exports = Code
