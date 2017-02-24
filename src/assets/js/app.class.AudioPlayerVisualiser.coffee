# Let me just preface this class by saying that for the most part here I've got no idea what I'm doing.
# This is my first foray into the web audio API and so far it's been confusing to say the least.
# However, my goal was to have a pretty dancing bars visualisation that reacts to the music and I feel like I've accomplished that.
class AudioPlayerVisualiser

	steps: 256

	constructor: (audioSource) ->

		@test = ko.observable('')

		# Create an audio context and connect it to the audio player
		@context = new (window.AudioContext or window.webkitAudioContext)

		@analyser = @context.createAnalyser()
		@analyser.fftSize = @steps
		@analyser.smoothingTimeConstant = 0.6
		@analyser.minDecibels = -80
		@analyser.maxDecibels = 10

		@source = @context.createMediaElementSource(audioSource)
		@source.connect(@analyser)
		@analyser.connect(@context.destination)

		# Define observable data
		@data = []
		for i in [0..@analyser.frequencyBinCount / 4]
			@data.push(ko.observable(0))

		window.requestAnimationFrame(=> do @updateVisualiser)



	updateVisualiser: ->
		data = new Float32Array(@analyser.frequencyBinCount)
		@analyser.getFloatFrequencyData(data)

		for i in [0..@analyser.frequencyBinCount / 4]
			height = (data[i] + 100)
			height = 0 if height < 0
			@data[i](height + 'px')

		window.requestAnimationFrame(=> do @updateVisualiser)
