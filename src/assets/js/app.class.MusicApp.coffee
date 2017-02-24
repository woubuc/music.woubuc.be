class MusicApp

	constructor: ->
		@library = new TrackLibrary(@)
		@player = new AudioPlayer

		@app = ko.observable('library')

		if window.location.hash isnt ''
			hash = window.location.hash.replace('#', '')
			if hash.indexOf('/')
				hash = hash.split('/')[0]

			hash = parseInt(hash)
			return if not isFinite(hash)

			@selectTrack(hash, no)


	showLibrary: ->
		@app('library')

		window.location.hash = ''

	showPlayer: ->
		return if not @library.currentTrack()

		@app('player')

		window.location.hash = @library.currentTrackId() + '/' + @library.currentTrack().title().toLowerCase().replace(/\s+/g, '-').replace(/[^-|^\w]/g, '')


	selectTrack: (track, play = yes) =>

		# If we're already playing the same track, just switch to the player
		if track is @library.currentTrackId()
			do @showPlayer
			return

		# Stop playing current track (if any)
		@player.stop()

		# Select the new track from the library
		@library.selectTrack(track)

		# Load the track and start playing if required
		if play
			@player.playTrack(@library.currentTrack())
		else
			@player.loadTrack(@library.currentTrack())

		# Switch view to the player
		do @showPlayer
