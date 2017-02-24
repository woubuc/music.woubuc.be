class TrackLibrary

	constructor: (@app) ->

		# Load tracks into observable array
		@tracks = ko.observableArray([])
		for trackData in window.tracks
			track = new Track(trackData)
			track.id = @tracks().length
			@tracks.push(track)

		# Sort tracks by date (reverse chronological order)
		@trackList = ko.pureComputed =>
			@tracks().concat().sort (a, b) ->
				if b.year is a.year
					return b.month - a.month
				else
					return b.year - a.year

		# Keep track of current track
		@currentTrackId = ko.observable(null)
		@currentTrack = ko.observable(null)


	getTrack: (trackId) ->
		@tracks()[trackId]

	selectTrack: (trackId) ->
		@currentTrackId(trackId)
		@currentTrack(@tracks()[trackId])
