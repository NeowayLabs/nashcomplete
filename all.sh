# nash-complete

import deps
import common
import kill
import systemd
import history
import files
import programs

var OS <= uname -s

var sedArgs = "-r"

if $OS == "Darwin" {
	sedArgs = "-E"
}

var NASHCOMPLETE_CMD = (
	("kill" $nash_complete_kill)
	("systemctl" $nash_complete_systemctl)
)

fn nash_complete_args(parts, line, pos) {
	if len($parts) == "0" {
		return ()
	}

	var cmd = $parts[0]

	for completecmd in $NASHCOMPLETE_CMD {
		var name = $completecmd[0]
		var callback = $completecmd[1]
		var ret = ""

		if $cmd == $name {
			var ret <= $callback($parts, $line, $pos)

			return $ret
		}
	}

	ret <= nash_complete_paths($parts, $line, $pos)

	return $ret
}

fn nash_complete(line, pos) {
	var ret = ""

	if $line == "" {
		# search in the history
		ret <= nash_complete_history()

		return $ret
	}

	var parts <= split($line, " ")

	if len($parts) == "0" {
		# not sure when happens
		return ()
	} else if len($parts) == "1" {
		var _, status <= echo $line | grep "^\\." >[1=]

		if $status == "0" {
			ret <= nash_complete_paths($parts, $line, $pos)

			return $ret
		}

		var _, status <= echo $line | grep " $" >[1=]

		if $status != "0" {
			ret <= nash_complete_program($line, $pos)

			return $ret
		}
	}

	ret <= nash_complete_args($parts, $line, $pos)

	return $ret
}
