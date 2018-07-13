# Autocomplete of files

fn nash_complete_paths(parts, line, pos) {
	var partsz <= len($parts)
	var last <= -expr $partsz - 1
	var last <= trim($last)
	var lastpart <= echo -n $parts[$last] | sed $sedArgs "s#^~#"+$HOME+"#g"

	var dir = ""
	var fname = ""
	var dirpath = ""

	var _, status <= test -d $lastpart

	if $status == "0" {
		# already a directory
		echo -n $lastpart | -grep "/$" >[1=]
		
		# complete with '/' if it wasnt given
		if $status != "0" {
			return ("/" "0")
		}
		
		dir <= echo $lastpart | sed $sedArgs "s#/$##g"
		
		dirpath = $dir+"/"
		fname   = ""
	} else {
		dir <= dirname $lastpart | tr -d "\n"
		
		if $dir != "/" {
			dirpath = $dir+"/"
		} else {
			dirpath = $dir
		}
		
		fname <= basename $lastpart | tr -d "\n"
	}
	if $fname == "/" {
		fname = ""
	}

	var _, status <= test -d $dir

	if $status != "0" {
		# autocompleting non-existent directory
		return ()
	}

	var choice, status <= (
		find $dir -maxdepth 1 |
		sed "s#"+$dirpath+"##g" |
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

	var _, status <= test -d $dir+$choice

	if $status == "0" {
		echo $choice | -grep "/$" >[1=]
		
		if $status != "0" {
			choice = $choice+"/"
		}
	}

	choice <= diffword($choice, $fname)

	return ($choice "0")
}
