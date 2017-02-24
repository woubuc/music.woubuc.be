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
		@currentTrack = ko.observable(null)


	selectTrack: (trackId) ->
		@currentTrack(@tracks()[trackId])
