class MusicApp

	constructor: ->
		@library = new TrackLibrary(@)
		@player = new AudioPlayer


	selectTrack: (track) =>

		# Stop playing current track (if any)
		@player.stop()

		# Start playing the new track
		@library.selectTrack(track)
		@player.playTrack(@library.currentTrack())
