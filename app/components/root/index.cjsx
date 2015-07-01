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
StatusBar = require 'components/statusbar'
Stage = require 'components/stage'
Screen = require 'components/screen'

# Static methods
setInitialized = (delay = 1000) ->
	setTimeout ->
		RootActions.call null, RootConst.SET_INITIALIZED, true
	, delay

socketConnect = (delay = 3000) ->
	setTimeout ->
		WS._devConnect()
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
			<StatusBar initialized={ root.initialized } socket={ socket.status } />
			<Stage />
			<Screen width={ site.width } height={ site.height } />
		</div>

	componentDidMount: ->
		setInitialized()
		socketConnect()

# Successfully required in
module.exports = Root