# Autocomplete of files

fn nash_complete_wildcard(line, dir, fname, pos) {
	pat   <= echo $fname | sed "s/\\*/.*/g"
	files <= ls $dir | grep "^"+$pat

	if $status != "0" {
		return ()
	}

	files <= split($files, "\n")

	# used to calculate how many chars to override
	tmp   <= echo $line | sed "s/[a-zA-Z-]*\\*.*//g"
	pos   <= len($tmp)

	out   = ""
	first = "0"

	for f in $files {
		if $first == "0" {
			comp <= echo -n $f | sed "s#"+$tmp+"##g"

			out   = $out+$comp+" "
			first = "1"
		} else {
			if $dir != "" {
				out = $out+$dir+$f+" "
			} else {
				out = $out+$f+" "
			}
		}
	}

	return ($out $pos)
}

fn nash_complete_paths(parts, line, pos) {
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
		return ()
	}

	echo -n $fname | -grep "\\*" >[1=]

	if $status == "0" {
		return nash_complete_wildcard($line, $dir, $fname, $pos)
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
