# autocomplete of system-wide binaries

fn nash_complete_program(line, pos) {
	ret    = ()

	paths  <= getpaths()
	choice <= (
		find $paths -maxdepth 1 -type f |
		sed "s#/.*/##g" |
		sort -u |
		-fzf -q "^"+$line
				-1
				-0
				--header "Looking for system-wide binaries"
				--prompt "(λ programs)>"
				--reverse

	)

	if $status != "0" {
		return $ret
	}

	choice <= diffword($choice, $line)

	ret = ($choice+" " "0")

	return $ret
}
