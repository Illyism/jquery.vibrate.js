"use strict"

###
Vibration API
Copyright (C) 2014  Ilias Ismanalijev

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see http://www.gnu.org/licenses/
###


$ = jQuery
$.fn.vibrate = (options) ->
	debug = () ->
	if options?
		if options.debug? and options.debug is on
			debug = (msg) ->
				console.log "Vibration : #{msg}"
		if typeof options is "string"
			switch options
				when "short"
					options = duration: 20
					debug "Duration = 20"
				when "medium", "default"
					options = duration: 50
					debug "Duration = 50"
				when "long"
					options = duration: 100
					debug "Duration = 100"
		else if typeof options is "number"
			options = duration: options unless isNaN options
			debug "Duration = #{options}"
	else
		options = {}

	canVibrate = "vibrate" of navigator || "mozVibrate" of navigator	

	debug "Can Vibrate = #{canVibrate}"
	if canVibrate is no
		this
	else if canVibrate is yes
		$(this).each () ->
			$this = $(this)

			$this.defaults =
				trigger: "click"
				duration: 50
				vibrateClass: "vibrate"
				debug: false


			# Settings Options
			if typeof options == "object"
				$this.defaults = $.extend $this.defaults, options 
				
			triggerStop = null
			if ($this.defaults.trigger is "mousedown")
				triggerStop = "mouseup";
				debug "StopEvent = mouseup"

			if ($this.defaults.trigger is "touchstart")
				triggerStop = "touchend";
				debug "StopEvent = touchend"

			$this.addClass $this.defaults.vibrateClass if not $this.hasClass "vibrate"
			debug "Class = #{$this.defaults.vibrateClass}"

			# Binding to trigger
			$this.bind $this.defaults.trigger, () ->
				debug "Vibrate #{$this.defaults.duration}ms"
				if "vibrate" of navigator
					navigator.vibrate $this.defaults.pattern or $this.defaults.duration
				else if "mozVibrate" of navigator
					navigator.mozVibrate $this.defaults.pattern or $this.defaults.duration
			if (triggerStop?)
				$this.bind triggerStop, () ->
					debug "Vibrate Stop"
					if "vibrate" of navigator
						navigator.vibrate 0
					else if "mozVibrate" of navigator
						navigator.mozVibrate 0