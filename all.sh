# nash-complete

import deps
import common
import kill
import systemd
import history
import files
import programs

var UNIXTOOLS = ("ls" "echo" "cat" "sed" "grep")
var NASHCOMPLETE_CMD = (
	("kill" $nash_complete_kill)
	("systemctl" $nash_complete_systemctl)
)

fn abort(msg) {
	print("[nashcomplete] error: %s\n", $msg)
}

fn init() {
	for tool in $UNIXTOOLS {
		var _, status <= which $tool >[2=]

		if $status != "0" {
			abort("Unix tool not installed: "+$tool+" not found")
		}
	}
}

fn nash_complete_args(parts, line, pos) {
	if len($parts) == "0" {
		return ()
	}

	var cmd = $parts[0]
	var name = ""
	var callback = ""
	var ret = ""

	for completecmd in $NASHCOMPLETE_CMD {
		name     = $completecmd[0]
		callback = $completecmd[1]

		if $cmd == $name {
			ret <= $callback($parts, $line, $pos)
			
			return $ret
		}
	}

	ret <= nash_complete_paths($parts, $line, $pos)

	return $ret
}

fn nash_complete(line, pos) {
	var ret = ""
	var parts = ""

	if $line == "" {
		# search in the history
		ret <= nash_complete_history()
		
		return $ret
	}

	parts <= split($line, " ")

	ret = ()

	if len($parts) == "0" {
		# not sure when happens
		return ()
	} else if len($parts) == "1" {
		_, status <= echo $line | grep "^\\."
		
		if $status == "0" {
			ret <= nash_complete_paths($parts, $line, $pos)
			
			return $ret
		}
		
		_, status <= echo $line | -grep " $"
		
		if $status != "0" {
			ret <= nash_complete_program($line, $pos)
			
			return $ret
		}
	}

	ret <= nash_complete_args($parts, $line, $pos)

	return $ret
}

init()
