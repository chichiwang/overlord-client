# @cjsx React.DOM
'use strict'

cx = require 'util/cx'
KeyStore = require 'util/keypress/store'

# Static variables
keyMap = {
  37: 'left', 39: 'right',
  48: '0', 49: '1', 50: '2', 51: '3',
  52: '4', 53: '5', 54: '6', 55: '7',
  56: '8', 57: '9', 96: '0', 97: '1',
  98: '2', 99: '3', 100: '4', 101: '5'
  102: '6', 103: '7', 104: '8', 105: '9'
}

# Static methods
_classes = ->
  cx({
    input: true
    row: true
    active: @props.active
  })

_cursorIsAtEnd = ->
  @state.position == @valLength - 1

_cursorIsAtStart = ->
  @state.position == 0

_cursorLeft = ->
  @setState { position: @state.position - 1 } unless _cursorIsAtStart.call(@)

_cursorRight = ->
  @setState { position: @state.position + 1 } unless _cursorIsAtEnd.call(@)

_cursorStyles = ->
  modifier = @state.position
  offset = @leftOffset + (@keyWidth / 2) - (@arrowWidth / 2)
  left = offset + (@keyWidth * modifier)
  { left: left + 'px' }

_incrementCursor = ->
  if _cursorIsAtEnd.call(@)
    @setState { position: 0 }
  else
    @setState { position: @state.position + 1 }

_keyPressed = (val) ->
  return unless @props.active
  keyCode = val.lastPressed
  # console.log 'Input | Key pressed >> ', val.lastPressed

  _cursorLeft.call(@) if keyMap[keyCode] == 'left'
  _cursorRight.call(@) if keyMap[keyCode] == 'right'

  if _keyIsNumeral(keyCode)
    @valueMap[@state.position] = keyMap[keyCode]
    @props.onUpdate(@valueMap.join(''))
    _incrementCursor.call(@)
    

_keyIsNumeral = (keyCode) ->
  (keyCode >= 48 && keyCode <= 57)  || (keyCode >= 96 && keyCode <= 105)

_makeCharacters = (val) ->
  keys = []
  return keys unless val && val.length
  chars = val.split('')
  for char in chars
    keys.push <span className="chara">{ char }</span>
  keys

_updateDimensions = ->
  keyInput = React.findDOMNode(@refs.keyInput)
  @leftOffset = parseInt(window.getComputedStyle(keyInput, null).getPropertyValue('padding-left').replace(/px$/, ''))
  @keyWidth = keyInput.children[0].offsetWidth
  @arrowWidth = React.findDOMNode(@refs.arrowDown).offsetWidth

# Input component definition
Input = React.createClass
  displayName: 'Input'
  valLength: 0
  valueMap: []

  keyWidth: 0
  leftOffset: 0
  arrowWidth: 0

  getInitialState: ->
    { position: 0 }

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
    @setState { position: 0 } unless newProps.active

  render: ->
    # console.log 'Input position: ', @state.position
    <div className={ @classes() } >
      <div className="label">
        { @props.label }
      </div>
      <div className="input-area">
        <div className="key-input" ref="keyInput">
          { _makeCharacters(@props.val) }
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
