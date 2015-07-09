# @cjsx React.DOM
'use strict'

cx = require 'util/cx'

# Static variables
keyMap = {
  13: 'enter',
  37: 'left', 39: 'right'
}

# Static methods
_classes = ->
  cx({
    button: true
    active: @props.active
    locked: @props.locked
  })

_clicked = ->
  @props.onClick?() unless @props.locked

_keyPressed = (e) ->
  keyCode = e.keyCode
  
  @props.onNext?() if keyMap[keyCode] == 'right'
  @props.onPrev?() if keyMap[keyCode] == 'left'
  _clicked.call(@) if keyMap[keyCode] == 'enter'

# Button component definition
Button = React.createClass
  displayName: 'Button'

  _bindKeypress: ->
    return false if @keyListenerBound
    @keyListenerBound = true
    document.addEventListener('keyup', @keyPressed)

  _unbindKeypress: ->
    return false unless @keyListenerBound
    @keyListenerBound = false
    document.removeEventListener('keyup', @keyPressed)

  componentWillMount: ->
    @keyPressed = _keyPressed.bind(@)
    @clicked = _clicked.bind(@)

  componentWillReceiveProps: (newProps) ->
    if newProps.active
      @_bindKeypress()
    else
      @_unbindKeypress()

  render: ->
    text = @props.text || "Button"
    text = @props.lockedText || "Locked!" if @props.locked

    <div className={ _classes.call(@) } onClick={ @clicked } >
      <span className="copy">{ text }</span>
      <span className="icon-tri-right" />
      <span className="icon-tri-left" />
    </div>

module.exports = Button
