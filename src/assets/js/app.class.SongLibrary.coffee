class SongLibrary

	constructor: (@app) ->

		@tracks = ko.observableArray([])

		@tracks.push
			title: 'Untitled (work in progress)'
			url: 'https://files.woubuc.be/music/nameless-wip-1.mp3'
			instruments: ['piano', 'horn', 'violin']


		@selectedId = ko.observable(-1)
		@currentTrack = ko.pureComputed => @tracks()[@selectedId()]
