class AudioPlayerUI

	constructor: (@player) ->

		# Keep track of when we're dragging the seeker
		@seeking = ko.observable(no)
		@seekingStart = ko.observable(0)
		@seekingCurrent = ko.observable(0)

		# How far along in the song we are in %
		@timePercentage = ko.pureComputed =>
			return 0 if @player.duration() is -1 or @player.state() is -1

			# When not seeking, return the current position percentage
			return (@player.position() / @player.duration() * 100) + '%' if not @seeking()

			# Else, return percentage
			return (@seekingCurrent() / window.innerWidth * 100) + '%'





		@timePercentageSeeker = ko.pureComputed =>
			return @timePercentage() if not @seeking()
			return (@seekingCurrent() / window.innerWidth * 100) + '%'


		# Make a nicely formatted label with the current position and the duration
		@timeLabel = ko.pureComputed =>
			return '-- / --' if @player.duration() is -1 or @player.state() is -1
			return formatTime(@player.position()) + ' / ' + formatTime(@player.duration())


	# Called when user clicks in the seek bar catchment area
	onSeek: (app, evt) ->

		# This should only do something when a track is playing or paused
		return if @player.state() not in [1, 2]

		# Figure out how far between the left and right side of the screen the user clicked in %
		seekPercentage = evt.clientX / window.innerWidth * 100

		# Figure out the position in the current track that corresponds to that percentage
		seekPosition = @player.duration() / 100 * seekPercentage

		# Seek to that position
		@player.seekTo(seekPosition)



	onDrag: (app, evt) =>
		return if @player.state() is -1

		@seeking(yes)
		@seekingStart(evt.clientX)


	onDrop: (app, evt) =>
		return if not @seeking()

		# Calculate position in track
		seekPercentage = @seekingCurrent() / window.innerWidth * 100
		seekPosition = @player.duration() / 100 * seekPercentage

		# Seek to that position
		@player.seekTo(seekPosition)

		# End seeking
		@seeking(no)


	onMove: (app, evt) =>
		return if not @seeking()
		@seekingCurrent(evt.clientX)



	onKey: (app, evt) =>

		switch evt.which

			# Space bar: play/pause
			when 32 then @player.togglePlayPause()

			# Other key events should be let through to the browser
			else return true
