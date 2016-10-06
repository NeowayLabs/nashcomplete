# systemd related autocomplete

fn nash_complete_systemctlopt(parts, line, pos) {
	ret    = ()
	IFS    = ()

	choice <= (
		echo "sucks enable disable start stop reload-daemon" |
		tr " " "\n" |
		-fzf --header "Systemd options:"
	)

	choice <= trim($choice)

	ret    = ($choice+" " "0")

	return $ret
}

fn nash_complete_systemctl(parts, line, pos) {
	ret    = ()
	IFS    = ()

	partsz <= len($parts)

	if $partsz == "1" {
		ret <= nash_complete_systemctlopt($parts, $line, $pos)

		return $ret
	}

	choice <= (
		-find /etc/systemd/
				 |
		-grep "service$"
				 |
		sed "s#/.*/##g" |
		sed "s/\\.service//g" |
		fzf --header "select unit: "
	)

	choice <= trim($choice)

	ret    = ($choice "0")

	return $ret
}
