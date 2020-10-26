# autocomplete of system-wide binaries

fn nash_complete_program(line, pos) {
	var paths <= getpaths()
	var choice, status <= (
		find $paths -maxdepth 1 -type f -follow
						>[2=] |
		sed "s#/.*/##g" |
		sort --unique |
		fzf --query "^"+$line
				--select-1
				--exit-0
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
