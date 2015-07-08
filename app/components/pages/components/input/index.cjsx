# @cjsx React.DOM
'use strict'

cx = require 'util/cx'
KeyStore = require 'util/keypress/store'

# Static variables
keyMap = {
  37: 'left'
  39: 'right'
  48: '0'
  49: '1'
  50: '2'
  51: '3'
  52: '4'
  53: '5'
  54: '6'
  55: '7'
  56: '8'
  57: '9'
}

# Static methods
_classes = ->
  cx({
    input: true
    row: true
    active: @props.active
  })

_cursorStyles = ->
  modifier = @state.position - 1
  offset = @leftOffset + (@keyWidth / 2) - (@arrowWidth / 2)
  left = offset + (@keyWidth * modifier)
  { left: left + 'px' }

_keyPressed = (val) ->
  return unless @props.active
  keyCode = val.lastPressed
  # console.log 'Input | Key pressed >> ', val.lastPressed

  if keyMap[keyCode] == 'left'
    @setState { position: @state.position - 1 } unless @state.position == 1
  if keyMap[keyCode] == 'right'
    @setState { position: @state.position + 1 } unless @state.position == @valLength

  if _keyIsNumeral(keyCode)
    @valueMap[@state.position - 1] = keyMap[keyCode]

    @props.onUpdate(@valueMap.join(''))

    if @state.position == @valLength
      @setState { position: 1 }
    else
      @setState { position: @state.position + 1 }

_keyIsNumeral = (keyCode) ->
  keyCode > 47 && keyCode < 58

_generateKeys = (val) ->
  keys = []
  return keys unless val && val.length
  chars = val.split('')
  for char in chars
    keys.push <span className="key">{ char }</span>
  keys

_updateDimensions = ->
  keyInput = React.findDOMNode(@refs.keyInput)
  @leftOffset = parseInt(window.getComputedStyle(keyInput, null).getPropertyValue('padding-left').replace(/px$/, ''))
  @keyWidth = keyInput.children[0].offsetWidth
  @arrowWidth = React.findDOMNode(@refs.arrowDown).offsetWidth

# Component class definition
Input = React.createClass
  displayName: 'Input'
  valLength: 0
  valueMap: []

  keyWidth: 0
  leftOffset: 0
  arrowWidth: 0

  getInitialState: ->
    { position: 1 }

  componentWillMount: ->
    @classes = _classes.bind(@)
    @cursorStyles = _cursorStyles.bind(@)
    @updateDimensions = _updateDimensions.bind(@)

    @valLength = @props.val.length if @props.val
    @valueMap = @props.val.split('') if @props.val

    @keypressHandler = _keyPressed.bind(@)
    KeyStore.on('change', @keypressHandler)

  componentWillReceiveProps: (newProps) ->
    @valueMap = newProps.val.split('') if newProps.val
    @setState { position: 1 } unless newProps.active

  render: ->
    # console.log 'Input position: ', @state.position
    <div className={ @classes() } >
      <div className="label">
        { @props.label }
      </div>
      <div className="input-area">
        <div className="key-input" ref="keyInput">
          { _generateKeys(@props.val) }
          <span className="icon-tri-right" />
          <span className="icon-tri-left" />
          <span className="icon-tri-down" ref="arrowDown" style={ @cursorStyles() } />
          <span className="icon-tri-up" style={ @cursorStyles() } />
        </div>
      </div>
    </div>

  componentDidUpdate: ->
    @updateDimensions()

  componentWillUnmount: ->
    Keystore.off('change', @keypressHandler)

module.exports = Input
