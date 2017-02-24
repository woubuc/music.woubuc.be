class AudioPlayer

	constructor: ->

		# Create audio element
		@audio = document.createElement('audio')
		@audio.volume = 1
		@audio.preload = 'metadata'
		@audio.style.display = 'none'
		@audio.crossOrigin = 'anonymous'
		document.body.append(@audio)


		# Playback state
		@state = ko.observable('stopped')
		@audio.addEventListener('waiting', (=> @state('buffering')), false)
		@audio.addEventListener('playing', (=> @state('playing')), false)
		@audio.addEventListener('pause', (=> @state('paused')), false)
		@audio.addEventListener('ended', (=> @state('stopped')), false)


		# Keep track of duration of the current track
		@duration = ko.observable(-1)
		@audio.addEventListener('durationchange', (=> @duration(@audio.duration)), false)


		# Keep track of position by updating it at a regular pace
		# I've opted to not use the timeupdate event because (per the spec) it doesn't fire at a consistent pace and the seek bar looked a bit "jumpy" because of that
		@position = ko.observable(-1)
		@positionInterval = null

		# Subscribe to the change of play state
		# To adjust playing state and position update interval
		@state.subscribe (state) =>
			if state is 'playing'

				# Only set an interval when the track is actually playing
				@positionInterval = setInterval (=> @position(@audio.currentTime)), 100

				# Set playing property on track
				@currentTrack.playing(yes) if @currentTrack?

			else
				# Update the position one last time on pause/stop to get the current value, then clear the interval
				# I haven't noticed any issues (performance or otherwise) when keeping the interval running, but I figure this is the cleanest and the most obvious way to handle it
				# No need for the interval to run when the position won't change anyways
				@position(@audio.currentTime)
				clearInterval(@positionInterval)

				# Set playing property on track
				@currentTrack.playing(no) if @currentTrack?


		# Attach the UI events
		@ui = new AudioPlayerUI(@)

		# Create visualiser if supported
		@visualiser = null
		if Modernizr.webaudio and Modernizr.flexbox
			@visualiser = new AudioPlayerVisualiser(@audio)



	# Prepares a file to be played
	loadUrl: (url) ->

		# Don't do anything when the requested URL is already set
		return if @audio.src is url

		# Reset metadata properties
		@duration(-1)
		@position(-1)

		# Set the URL
		@audio.src = url

	# Loads a file and starts playing it
	playTrack: (@currentTrack) ->
		@loadUrl(@currentTrack.url)
		@audio.play()

	stop: ->
		@currentTrack.playing(no) if @currentTrack?
		@audio.src = ''

	seekTo: (position) ->
		return if @duration() is -1
		return if @duration() < position
		@position(position)
		@audio.currentTime = position


	play: ->
		@audio.play()

	pause: ->
		@audio.pause()

	togglePlayPause: =>
		if @state() in ['buffering', 'playing']
			@pause()
		else
			@play()
