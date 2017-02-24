# The init() function creates a new instance of MusicApp and applies the Knockout bindings
init = ->

	# Check if the HTML5 <audio> element is supported
	# Modernizr FTW
	if not Modernizr.audio
		document.body.innerHTML = '<p style="margin:10px 15px">Your browser does not seem to support HTML5 &lt;audio&gt;, sorry. Try again in a different browser.<br>Believe this is wrong? <a href="https://twitter.com/woubuc" target="_blank">Let me know!</p>'
		return

	# Everything looks fine, time to apply those bindings!
	ko.applyBindings(new MusicApp)



# The formatTime() function returns a (hh:)mm:ss string from a number of seconds
formatTime = (seconds) ->

	# Simple helper function to prefix zeroes in front of single-digit numbers
	prefix = (number) -> if number < 10 then '0' + number else number

	# Return zero if seconds is negative
	return '--' if seconds < 0

	# First, round the seconds down cause I don't want to display milliseconds
	seconds = Math.floor(seconds)

	# If less than 60 seconds remain, just return the seconds
	return '00:' + prefix(seconds) if seconds < 60

	# Calculate minutes and remaining seconds
	minutes = Math.floor(seconds / 60)
	seconds = seconds % 60

	# If the time is less than an hour, format the minutes and seconds
	if minutes < 60
		return prefix(minutes) + ':' + prefix(seconds)

	# Calculate hours
	hours = Math.floor(minutes / 60)
	minutes = minutes % 60

	# We're not going any bigger than hours
	# Also hours don't need to be prefixed
	return hours + ':' + prefix(minutes) + ':' + prefix(seconds)


# Gets the month from a month number
monthName = (month) -> switch month
	when 1 then 'jan'
	when 2 then 'feb'
	when 3 then 'mar'
	when 4 then 'apr'
	when 5 then 'may'
	when 6 then 'jun'
	when 7 then 'jul'
	when 8 then 'aug'
	when 9 then 'sep'
	when 10 then 'oct'
	when 11 then 'nov'
	when 12 then 'dec'



# Helper shorthand function to select an element by ID
el = (id) -> return document.getElementById(id)
