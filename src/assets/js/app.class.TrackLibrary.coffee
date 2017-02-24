class TrackLibrary

	constructor: (@app) ->

		# Load tracks into observable array
		@tracks = ko.observableArray([])
		@tracks.push(new Track(trackData)) for trackData in window.tracks

		# Sort tracks by date (reverse chronological order)
		@tracks.sort (a, b) ->
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
