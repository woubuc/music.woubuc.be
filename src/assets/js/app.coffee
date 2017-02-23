class MusicApp

	constructor: ->
		@tracks = ko.observableArray([])

		@tracks.push(name: 'Nameless (WIP)', url: 'https://files.woubuc.be/music/nameless-wip-1.mp3')

		@playingStatus = ko.observable(false)
		@playingStatusClass = ko.pureComputed(=> if @playingStatus() is on then 'fa-pause' else 'fa-play')

		@player = new AudioPlayer


	play: ->
		@playingStatus on

	pause: ->
		@playingStatus off

	setTrack: (track) =>

		console.log(track)
		@player.playUrl(track.url)



init = ->
	ko.applyBindings(new MusicApp)



class AudioPlayer

	constructor: ->

		# Create audio element
		@audio = document.createElement('audio')
		@audio.preload = 'metadata'

		# Set up observable properties
		@loaded = ko.observable(no)
		@loadedMetadata = ko.observable(no)

		@length = ko.observable(0)
		@position = ko.observable(0)

		# Add event listeners
		@audio.addEventListener('loadedmetadata', @evtLoadedMetadata, false)
		@audio.addEventListener('loadeddata', @evtLoadedData, false)


	# Fires when metadata for a track is loaded
	evtLoadedMetadata: =>
		@length(@audio.duration)
		@loadedMetadata(yes)
		console.log('Metadata loaded')

	# Fires when the first bit of music is loaded
	evtLoadedData: =>
		@loaded(yes)
		console.log('First data loaded')


	loadUrl: (url) ->
		@loaded(no)
		@loadedMetadata(no)
		@audio.src = url

	playUrl: (url) ->
		@loadUrl(url)
		@audio.play()
