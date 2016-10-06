# nash-complete

import deps
import common
import kill
import history
import files
import programs

fn nash_complete_args(parts, line, pos) {
	ret = ()

	partsz <= len($parts)

	if $partsz == "0" {
		return $ret
	}

	cmd = $parts[0]

	if $cmd == "kill" {
		ret <= nash_complete_kill($parts, $line, $pos)

		return $ret
	}

	ret <= nash_complete_paths($parts, $line, $pos)

	return $ret
}

fn nash_complete(line, pos) {
	ret = ()
	IFS = ("\n")

	if $line == "" {
		# search in the history
		ret <= nash_complete_history()

		return $ret
	}

	parts  <= echo $line | tr " " "\n"
	partsz <= len($parts)

	if $partsz == "0" {
		# not sure when happens
		return $ret
	} else if $partsz == "1" {
		echo $line | -grep " $" >[1=]

		if $status != "0" {
			ret <= nash_complete_program($line, $pos)

			return $ret
		}
	}

	ret <= nash_complete_args($parts, $line, $pos)

	return $ret
}
