class AudioPlayerUI

	constructor: (@player) ->

		# Keep track of when we're dragging the seeker
		@seeking = ko.observable(no)
		@seekingStart = ko.observable(0)
		@seekingCurrent = ko.observable(0)

		# How far along in the song we are in %
		@timePercentage = ko.pureComputed =>
			return 0 if @player.duration() is -1 or @player.state() is 'stopped'

			# When not seeking, return the current position percentage
			return (@player.position() / @player.duration() * 100) + '%' if not @seeking()

			# Else, return percentage
			console.log(@seekingCurrent())
			return @seekingCurrent() + '%'


		@timePercentageSeeker = ko.pureComputed =>
			return @timePercentage() if not @seeking()
			return (@seekingCurrent() / window.innerWidth * 100) + '%'


		# Make a nicely formatted label with the current position and the duration
		@timeLabel = ko.pureComputed =>
			return '-- / --' if @player.duration() is -1
			return '-- / ' + formatTime(@player.duration()) if @player.state() is 'stopped'
			return formatTime(@player.position()) + ' / ' + formatTime(@player.duration())






	# Called when user clicks in the seek bar catchment area
	onSeek: (app, evt) =>

		# This should only do something when a track is playing or paused
		return if @player.state() not in ['playing', 'paused']

		# Figure out how far between the left and right side of the seek bar the user clicked in %
		seekPosition = @player.duration() / 100 * @calculatePercentageOfSeekBar(evt.clientX)

		# Seek to that position
		@player.seekTo(seekPosition)


	onDrag: (app, evt) =>
		return if @player.state() is 'stopped'

		@seeking(yes)
		@seekingStart(evt.clientX)
		@onMove(app, evt)

	onDragTouch: (app, evt) =>
		@onDrag(app, clientX: evt.touches[0].clientX)
		return true


	onDrop: (app, evt) =>
		return true if not @seeking()

		# Calculate position in track
		seekPosition = @player.duration() / 100 * @seekingCurrent()

		# Seek to that position
		@player.seekTo(seekPosition)

		# End seeking
		@seeking(no)


	onMove: (app, evt) =>
		return true if not @seeking()
		@seekingCurrent(@calculatePercentageOfSeekBar(evt.clientX))

	onMoveTouch: (app, evt) =>
		@onMove(app, clientX: evt.touches[0].clientX)
		return true



	onKey: (app, evt) =>

		switch evt.which

			# Space bar: play/pause
			when 32 then @player.togglePlayPause()

			# Other key events should be let through to the browser
			else return true



	calculatePercentageOfSeekBar: (clientX) ->
		if window.innerWidth < 500
			offset = (clientX - 40) / (window.innerWidth - 80) * 100
			return offset

		offsetFromLeftEdge = (clientX - el('app').offsetLeft - 40 + (el('app').offsetWidth / 2))
		barWidth = (el('app').offsetWidth - 80)
		seekPercentage = (offsetFromLeftEdge / barWidth) * 100
		return seekPercentage
