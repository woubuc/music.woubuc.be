class AudioPlayer

	constructor: ->

		# Create audio element
		@audio = document.createElement('audio')
		@audio.preload = 'metadata'

		# Playback state
		# -1 = stopped / unloaded
		# 0 = buffering
		# 1 = paused
		# 2 = playing
		@state = ko.observable(-1)
		@audio.addEventListener('waiting', (=> @state(0)), false)
		@audio.addEventListener('playing', (=> @state(2)), false)
		@audio.addEventListener('pause', (=> @state(1)), false)
		@audio.addEventListener('ended', (=> @state(-1)), false)

		# Keep track of duration of the current track
		@duration = ko.observable(-1)
		@audio.addEventListener('durationchange', (=> @duration(@audio.duration)), false)

		# Keep track of position by updating it at a regular pace
		# I've opted to not use the timeupdate event because (per the spec) it doesn't fire at a consistent pace and the seek bar looked a bit "jumpy" because of that
		@position = ko.observable(-1)
		@positionInterval = null

		@state.subscribe (state) =>
			if state is 2
				# Only set an interval when the track is actually playing
				@positionInterval = setInterval (=> @position(@audio.currentTime)), 200

			else
				# Update the position one last time on pause/stop to get the current value, then clear the interval
				# I haven't noticed any issues (performance or otherwise) when keeping the interval running, but I figure this is the cleanest and the most obvious way to handle it
				# No need for the interval to run when the position won't change anyways
				@position(@audio.currentTime)
				clearInterval(@positionInterval)


		# Attach UI
		@ui = new AudioPlayerUI(@)



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
	playUrl: (url) ->
		@loadUrl(url)
		@audio.play()


	seekTo: (position) ->
		return if @duration() is -1
		return if @duration() < position
		@audio.currentTime = position


	play: ->
		@state(2)
		@audio.play()

	pause: ->
		@state(1)
		@audio.pause()

	togglePlayPause: =>
		if @state() is 2
			@pause()
		else
			@play()
