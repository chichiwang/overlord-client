# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

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

_clicked = ->
  @props.onClick?()

_cursorIsAtEnd = ->
  @state.position == @valLength - 1

_cursorIsAtStart = ->
  @state.position == 0

_cursorStyles = ->
  modifier = @state.position
  offset = @leftOffset + (@keyWidth / 2) - (@arrowWidth / 2)
  left = offset + (@keyWidth * modifier)
  { left: left + 'px' }

_incrementCursor = ->
  if _cursorIsAtEnd.call(@)
    @props.onNext?()
  else
    @setState { position: @state.position + 1 }

_decrementCursor = ->
  if _cursorIsAtStart.call(@)
    @props.onPrev?()
  else
    @setState { position: @state.position - 1 }

_keyPressed = (e) ->
  return unless @props.active
  keyCode = e.keyCode
  # console.log 'Input | Key pressed >> ', @props.label, @state.position

  _decrementCursor.call(@) if keyMap[keyCode] == 'left'
  _incrementCursor.call(@) if keyMap[keyCode] == 'right'

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

  keyListenerBound: false
  keyPressed: undefined

  _bindKeypress: ->
    return false if @keyListenerBound
    @keyListenerBound = true
    document.addEventListener('keyup', @keyPressed)

  _unbindKeypress: ->
    return false unless @keyListenerBound
    @keyListenerBound = false
    document.removeEventListener('keyup', @keyPressed)

  getInitialState: ->
    { position: 0 }

  componentWillMount: ->
    @valLength = @props.val.length if @props.val
    @valueMap = @props.val.split('') if @props.val
    @clicked = _clicked.bind(@)
    @keyPressed = _keyPressed.bind(@)

  componentWillReceiveProps: (newProps) ->
    @valueMap = newProps.val.split('') if newProps.val

    if newProps.active
      @_bindKeypress()
    else
      @setState { position: 0 }
      @_unbindKeypress()

  render: ->
    # console.log 'Input position: ', @state.position
    <div className={ _classes.call(@) } onClick={ @clicked }>
      <div className="label">
        { @props.label }
      </div>
      <div className="input-area">
        <div className="key-input" ref="keyInput">
          { _makeCharacters(@props.val) }
          <span className="icon-tri-right" />
          <span className="icon-tri-left" />
          <span className="icon-tri-down" ref="arrowDown" style={ _cursorStyles.call(@) } />
          <span className="icon-tri-up" style={ _cursorStyles.call(@) } />
        </div>
      </div>
    </div>

  componentDidUpdate: ->
    _updateDimensions.call(@)

module.exports = Input
