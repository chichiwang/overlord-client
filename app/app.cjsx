# @cjsx React.DOM
'use strict'

SiteEvents = require 'util/site'
Root = require 'components/root'

# Initialize React's touch events
React.initializeTouchEvents(true)

initialize = ->
	SiteEvents.initialize()

	React.initializeTouchEvents(true)
	React.render <Root />, document.getElementById('Site-Container') if Root

initialize()