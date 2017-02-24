class MusicApp

	constructor: ->
		@library = new TrackLibrary(@)
		@player = new AudioPlayer

		@app = ko.observable('library')

		# @selectTrack(Math.floor(Math.random() * @library.tracks().length))


	showLibrary: ->
		@app('library')

	showPlayer: ->
		@app('player')


	selectTrack: (track) =>

		# If we're already playing the same track, just switch to the player
		if track is @library.currentTrackId()
			do @showPlayer
			return

		# Stop playing current track (if any)
		@player.stop()

		# Start playing the new track
		@library.selectTrack(track)
		@player.playTrack(@library.currentTrack())

		# Switch view to the player
		do @showPlayer
