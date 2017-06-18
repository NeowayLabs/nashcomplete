# Kill autocomplete

fn nash_complete_killopt(query, line, pos) {
	var queryOpt = ()

	if $query != "" {
		queryOpt = ("-q" "^"+$query)
	}

	var choice, status <= (
		echo "-1 HUP\n-2 INT\n-3 QUIT\n-4 ILL\n-5 TRAP\n-6 ABRT\n-6 IOT\n-7 BUS\n-8 FPE\n-9 KILL\n-10 USR1\n-11 SEGV\n-12 USR2\n-13 PIPE\n-14 ALRM\n-15 TERM\n-16 STKFLT\n-17 CHLD\n-17 CLD\n-18 CONT\n-19 STOP\n-20 TSTP\n-21 TTIN\n-22 TTOU\n-23 URG\n-24 XCPU\n-25 XFSZ\n-26 VTALRM\n-27 PROF\n-28 WINCH\n-29 IO\n-29 POLL\n-30 PWR\n-31 UNUSED\n-31 SYS\n-34 RTMIN\n-64 RTMAX" |
		-fzf --reverse
			--header
			"Select signal: " $queryOpt
	)

	if $status != "0" {
		return ()
	}

	choice <= trim($choice)

	var sig <= echo $choice | cut -d " " -f1

	if $query != "" {
		sig <= diffword($sig, $query)
	}

	return ($sig+" " "0")
}

fn nash_complete_kill(parts, line, pos) {
	var partsz <= len($parts)

	var ret = ()

	if $partsz == "0" {
		return $ret
	}
	if $partsz == "1" {
		ret <= nash_complete_killopt("", $line, $pos)

		return $ret
	}

	var last, _ <= expr $partsz - 1

	last <= trim($last)

	var lastpart = $parts[$last]
	var query = ()
	var querylen = "0"

	var _, status <= echo $lastpart | -grep "^-$"

	if $status == "0" {
		ret <= nash_complete_killopt($lastpart, $line, $pos)

		return $ret
	}

	_, status <= echo $lastpart | -grep "^-"

	if $status != "0" {
		_, status <= echo $line | -grep " $"

		if $status != "0" {
			query    = ("-q" "^"+$lastpart)
			querylen = "2"
		}
	}

	var pidsHeader = "select processes: (mark multiples with TAB)"

	# autocomplete pids
	var choice, status <= (
		ps -eo "pid,ppid,user,pcpu,pmem,args"
						--sort "%mem" |
		tr -s " " |
		sed -r "s/^ //g" |
		fzf --header $pidsHeader
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
