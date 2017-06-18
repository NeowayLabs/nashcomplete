# autocomplete of system-wide binaries

fn nash_complete_program(line, pos) {
	var paths <= getpaths()
	var choice, status <= (
		find $paths -maxdepth 1 -type f |
		sed "s#/.*/##g" |
		sort -u |
		fzf -q "^"+$line
				-1
				-0
				--header "Looking for system-wide binaries"
				--prompt "(λ programs)>"
				--reverse

	)

	if $status != "0" {
		return ()
	}

	choice <= diffword($choice, $line)

	return ($choice+" " "0")
}
