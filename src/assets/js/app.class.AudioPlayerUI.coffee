class AudioPlayerUI

	constructor: (@player) ->

		# How far along in the song we are in %
		@timePercentage = ko.pureComputed =>
			return 0 if @player.duration() is -1 or @player.state() is -1
			(@player.position() / @player.duration() * 100) + '%'

		# Make a nicely formatted label with the current position and the duration
		@timeLabel = ko.pureComputed =>
			return '-- / --' if @player.duration() is -1 or @player.state() is -1
			return formatTime(@player.position()) + ' / ' + formatTime(@player.duration())


	# Called when user clicks in the seek bar catchment area
	onSeek: (app, evt) ->

		# This should only do something when a track is playing
		return if @player.state() isnt 2

		# Figure out how far between the left and right side of the screen the user clicked in %
		seekPercentage = evt.clientX / window.innerWidth * 100

		# Figure out the position in the current track that corresponds to that percentage
		seekPosition = @player.duration() / 100 * seekPercentage

		# Seek to that position
		@player.seekTo(seekPosition)
