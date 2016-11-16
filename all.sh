# nash-complete

import deps
import common
import kill
import systemd
import history
import files
import programs

NASHCOMPLETE_CMD = (
	("kill" $nash_complete_kill)
	("systemctl" $nash_complete_systemctl)
)

fn nash_complete_args(parts, line, pos) {
	ret = ()

	if len($parts) == "0" {
		return $ret
	}

	cmd = $parts[0]

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
	ret = ()

	if $line == "" {
		# search in the history
		ret <= nash_complete_history()

		return $ret
	}

	parts <= split($line, " ")

	if len($parts) == "0" {
		# not sure when happens
		return $ret
	} else if len($parts) == "1" {
		# complete for local files
		echo $line | -grep "^\\."

		if $status == "0" {
			ret <= nash_complete_paths($parts, $line, $pos)

			return $ret
		}

		echo $line | -grep " $" >[1=]

		if $status != "0" {
			ret <= nash_complete_program($line, $pos)

			return $ret
		}
	}

	ret <= nash_complete_args($parts, $line, $pos)

	return $ret
}
