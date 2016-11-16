# Autocomplete of files

fn nash_complete_paths(parts, line, pos) {
	ret      = ()

	partsz   <= len($parts)
	last     <= -expr $partsz - 1
	last     <= trim($last)

	lastpart <= echo -n $parts[$last] | sed -r "s#^~#"+$HOME+"#g"

	-test -d $lastpart

	if $status == "0" {
		# already a directory
		dir   = $lastpart
		fname = ""
	} else {
		dir   <= dirname $lastpart | tr -d "\n"
		fname <= basename $lastpart | tr -d "\n"
	}

	echo -n $dir | -grep "/$" >[1=]

	if $status != "0" {
		dir = $dir+"/"
	}
	if $fname == "/" {
		fname = ""
	}

	-test -d $dir

	if $status != "0" {
		# autocompleting non-existent directory
		return $ret
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
		return $ret
	}

	-test -d $dir+$choice

	if $status == "0" {
		echo $choice | -grep "/$"

		if $status != "0" {
			choice = $choice+"/"
		}
	}

	choice <= diffword($choice, $fname)

	ret = ($choice "0")

	return $ret
}
