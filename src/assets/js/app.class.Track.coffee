class Track

	constructor: (trackData) ->

		@title = ko.observable(trackData.title)
		@duration = ko.observable(-1)
		@playing = ko.observable(no)

		@durationLabel = ko.pureComputed => formatTime(@duration())

		@url = trackData.url
		@image = trackData.image
		@instruments = trackData.instruments
		@instrumentsLabel = (if @instruments.length > 3 then @instruments.slice(0, 3) else @instruments).join(', ')

		@finished = if trackData.finished? then trackData.finished else yes

		@year = trackData.year
		@month = trackData.month
		@date = monthName(@month) + ' ' + @year

		do @loadMetadata


	# Loads the metadata of an audio file by creating an audio tag and setting the preload attribute to metadata
	loadMetadata: ->
		audio = document.createElement('audio')
		audio.preload = 'metadata'
		audio.style.display = 'none'
		document.body.append(audio)

		audio.addEventListener 'durationchange', (evt) =>
			@duration(audio.duration)
			document.body.removeChild(audio)

		, false

		audio.src = @url
