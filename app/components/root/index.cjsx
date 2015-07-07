# @cjsx React.DOM
'use strict'

# Stores
RootStore = require './store'
SiteStore = require 'util/site/store'
SocketStore = require 'util/websocket/store'

# Actions
RootActions = require './actions'

# Constants
RootConst = require './const'

# Helpers and utilities
SyncState = require 'util/mixins/syncstate'
WS = require 'util/websocket'

# Child views
Header = require 'components/header'
Stage = require 'components/stage'
ScreenOverlay = require 'components/overlay'

# Static methods
setInitialized = (delay = 1) ->
	setTimeout ->
		RootActions.call null, RootConst.SET_INITIALIZED, true
	, delay

socketConnect = (delay = 1500, connectedDelay = 4000) ->
	WS.setServer('ws://' + window.location.host + window.location.pathname)
	setTimeout ->
		WS._devConnecting()
		setTimeout ->
			WS.connect()
		, connectedDelay
	, delay

# Root View
Root = React.createClass
	displayName: 'Root'
	mixins: [SyncState]
	stores:
		root: RootStore
		site: SiteStore
		socket: SocketStore

	styles: ->
		{
			minHeight: @state.site.height + 'px'
		}

	render: ->
		root = @state.root
		site = @state.site
		socket = @state.socket

		<div id="Root" style={@styles()}>
			<Header initialized={ root.initialized } socket={ socket.status } />
			<Stage socket={ socket.status } bomb={ socket.message } />
			<ScreenOverlay width={ site.width } height={ site.height } />
		</div>

	componentDidMount: ->
		setInitialized()
		socketConnect()

# Successfully required in
module.exports = Root