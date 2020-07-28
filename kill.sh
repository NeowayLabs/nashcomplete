# Kill autocomplete

fn nash_complete_killopt(query, line, pos) {
	var queryOpt = ()

	if $query != "" {
		queryOpt = ("-q" "^"+$query)
	}

	var optlist = (
		"-1 HUP"
		"-2 INT"
		"-3 QUIT"
		"-4 ILL"
		"-5 TRAP"
		"-6 ABRT"
		"-6 IOT"
		"-7 BUS"
		"-8 FPE"
		"-9 KILL"
		"-10 USR1"
		"-11 SEGV"
		"-12 USR2"
		"-13 PIPE"
		"-14 ALRM"
		"-15 TERM"
		"-16 STKFLT"
		"-17 CHLD"
		"-17 CLD"
		"-18 CONT"
		"-19 STOP"
		"-20 TSTP"
		"-21 TTIN"
		"-22 TTOU"
		"-23 URG"
		"-24 XCPU"
		"-25 XFSZ"
		"-26 VTALRM"
		"-27 PROF"
		"-28 WINCH"
		"-29 IO"
		"-29 POLL"
		"-30 PWR"
		"-31 UNUSED"
		"-31 SYS"
		"-34 RTMIN"
		"-64 RTMAX"
	)

	var options <= join($optlist, "\n")

	var choice, status <= (
		echo $options |
		-fzf --reverse
			 --header "Select signal: " $queryOpt
	)

	if $status != "0" {
		return ()
	}

	choice <= trim($choice)

	var sig <= echo $choice | cut -d " " -f1 | tr -d "\n"

	if $query != "" {
		sig <= diffword($sig, $query)
	}

	return ($sig+" " "0")
}

fn nash_complete_kill(parts, line, pos) {
	var partsz <= len($parts)

	var ret = ""
	var last = ""

	if $partsz == "0" {
		return $ret
	}
	if $partsz == "1" {
		ret <= nash_complete_killopt("", $line, $pos)

		return $ret
	}

	last <= -expr $partsz - 1
	last <= trim($last)

	var lastpart = $parts[$last]
	var query = ()
	var querylen = "0"

	var _, status <= echo $lastpart | grep "^-$" >[1=]

	if $status == "0" {
		ret <= nash_complete_killopt($lastpart, $line, $pos)

		return $ret
	}

	echo $lastpart | -grep "^-" >[1=]

	if $status != "0" {
		echo $line | -grep " $" >[1=]

		if $status != "0" {
			query    = ("-q" "^"+$lastpart)
			querylen = "2"
		}
	}

	var pidsHeader = "select processes: (mark multiples with TAB)"

	# autocomplete pids
	var choice, status <= (
		ps -e -o "pid,ppid,user,pcpu,pmem,args" -m |
		tr -s " " |
		sed $sedArgs "s/^ //g" |
		-fzf --header $pidsHeader
					--header-lines=1
					-m
					--reverse $query
	)

	if $status != "0" {
		return ()
	}

	choice <= echo $choice | cut -d " " -f1 | tr "\n" " " | tr -s " "

	if $querylen == "2" {
		choice <= diffword($choice, $lastpart)
	}

	return ($choice "0")
}
