# Kill autocomplete

fn nash_complete_killopt(query, line, pos) {
	queryOpt = ()

	if $query != "" {
		queryOpt = ("-q" "^"+$query)
	}

	choice <= (
		echo "-1 HUP\n-2 INT\n-3 QUIT\n-4 ILL\n-5 TRAP\n-6 ABRT\n-6 IOT\n-7 BUS\n-8 FPE\n-9 KILL\n-10 USR1\n-11 SEGV\n-12 USR2\n-13 PIPE\n-14 ALRM\n-15 TERM\n-16 STKFLT\n-17 CHLD\n-17 CLD\n-18 CONT\n-19 STOP\n-20 TSTP\n-21 TTIN\n-22 TTOU\n-23 URG\n-24 XCPU\n-25 XFSZ\n-26 VTALRM\n-27 PROF\n-28 WINCH\n-29 IO\n-29 POLL\n-30 PWR\n-31 UNUSED\n-31 SYS\n-34 RTMIN\n-64 RTMAX" |
		-fzf --reverse
			--header
			"Select signal: " $queryOpt
	)

	if $status != "0" {
		return ()
	}

	choice <= trim($choice)
	sig    <= echo $choice | cut -d " " -f1 | tr -d "\n"

	if $query != "" {
		sig <= diffword($sig, $query)
	}

	return ($sig+" " "0")
}

fn nash_complete_kill(parts, line, pos) {
	partsz <= len($parts)

	if $partsz == "0" {
		return $ret
	}
	if $partsz == "1" {
		ret <= nash_complete_killopt("", $line, $pos)

		return $ret
	}

	last     <= -expr $partsz - 1
	last     <= trim($last)

	lastpart = $parts[$last]
	query    = ()
	querylen = "0"

	echo $lastpart | -grep "^-$" >[1=]

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

	pidsHeader = "select processes: (mark multiples with TAB)"

	# autocomplete pids
	choice <= (
		ps -eo "pid,ppid,user,pcpu,pmem,args"
						--sort "%mem" |
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
