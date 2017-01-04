# Autocomplete of files

fn nash_complete_paths(parts, line, pos) {
	partsz   <= len($parts)
	last     <= -expr $partsz - 1
	last     <= trim($last)
	lastpart <= echo -n $parts[$last] | sed $sedArgs "s#^~#"+$HOME+"#g"

	-test -d $lastpart

	if $status == "0" {
		# already a directory
		echo -n $lastpart | -grep "/$" >[1=]

		# complete with '/' if it wasnt given
		if $status != "0" {
			return ("/" "0")
		}

		dir   = $lastpart
		fname = ""
	} else {
		dir   <= dirname $lastpart | tr -d "\n"
		dir   = $dir+"/"
		fname <= basename $lastpart | tr -d "\n"
	}

	if $fname == "/" {
		fname = ""
	}

	-test -d $dir

	if $status != "0" {
		# autocompleting non-existent directory
		return ()
	}

	choice <= (
		find $dir -maxdepth 1 |
		sed "s#"+$dir+"##g" |
		-fzf -q "^"+$fname
				-1
				-0
				--header "Looking for path"
				--prompt "(λ path)>"
				--reverse
				 |
		tr -d "\n"
	)

	if $status != "0" {
		return ()
	}

	-test -d $dir+$choice

	if $status == "0" {
		echo $choice | -grep "/$" >[1=]

		if $status != "0" {
			choice = $choice+"/"
		}
	}

	choice <= diffword($choice, $fname)

	return ($choice "0")
}
