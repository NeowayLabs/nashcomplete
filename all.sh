# nash-complete

import deps
import common
import kill
import systemd
import history
import files
import programs

var GOBIN = $GOPATH+"/bin"
var ENZOTOOLS = ($GOBIN+"/ls" $GOBIN+"/echo" $GOBIN+"/cat")
var UNIXTOOLS = ("sed" "grep")
var NASHCOMPLETE_CMD = (
	("kill" $nash_complete_kill)
	("systemctl" $nash_complete_systemctl)
)

fn abort(msg) {
	echo "error: "+$msg

	exit(1)
}

fn init() {
	for tool in $ENZOTOOLS {
		if file_exists($tool) != "0" {
			abort("Enzo tools not installed: "+$tool+" not found")
		}
	}
	for tool in $UNIXTOOLS {
		which $tool >[1=]
	}

	paths <= split($PATH, ":")

	if $paths[0] != $GOBIN {
		abort($GOPATH+"/bin must precede other PATHs. Found "+$PATH)
	}
}

fn nash_complete_args(parts, line, pos) {
	if len($parts) == "0" {
		return ()
	}

	var cmd = $parts[0]

	for completecmd in $NASHCOMPLETE_CMD {
		var name = $completecmd[0]
		var callback = $completecmd[1]

		if $cmd == $name {
			var ret <= $callback($parts, $line, $pos)

			return $ret
		}
	}

	var ret <= nash_complete_paths($parts, $line, $pos)

	return $ret
}

fn nash_complete(line, pos) {
	if $line == "" {
		# search in the history
		var ret <= nash_complete_history()

		return $ret
	}

	var parts <= split($line, " ")

	var ret = ()

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
