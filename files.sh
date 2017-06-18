# Autocomplete of files

fn nash_complete_paths(parts, line, pos) {
	var partsz <= len($parts)
	var last <= -expr $partsz - 1

	last <= trim($last)

	var lastpart <= echo -n $parts[$last] | sed -r "s#^~#"+$HOME+"#g"
	var _, status <= test -d $lastpart

	var dir = $lastpart
	var fname = ""

	if $status != "0" {
		dir   <= dirname $lastpart
		fname <= basename $lastpart
	}

	_, status <= echo -n $dir | -grep "/$"

	if $status != "0" {
		dir = $dir+"/"
	}
	if $fname == "/" {
		fname = ""
	}

	_, status <= test -d $dir

	if $status != "0" {
		# autocompleting non-existent directory
		return ()
	}

	var choice, status <= (
		find $dir -maxdepth 1 |
		sed "s#"+$dir+"##g" |
		fzf -q "^"+$fname
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

	_, status <= test -d $dir+$choice

	if $status == "0" {
		_, status <= echo $choice | -grep "/$"

		if $status != "0" {
			choice = $choice+"/"
		}
	}

	choice <= diffword($choice, $fname)

	return ($choice "0")
}
