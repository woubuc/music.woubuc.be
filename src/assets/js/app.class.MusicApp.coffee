class MusicApp

	constructor: ->
		@library = new SongLibrary(@)
		@player = new AudioPlayer


	selectTrack: (track) =>
		@library.selectedId(track)
		@player.playUrl(@library.currentTrack().url)
