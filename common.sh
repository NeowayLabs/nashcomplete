# common functions


fn trim(value) {
	var value <= echo $value | tr -d "\n"

	return $value
}

fn diffword(complete, line) {
	var diff <= echo -n $complete | sed "s#^"+$line+"##g" | tr -d "\n"

	return $diff
}

fn join(list, sep) {
	var str = ""

	for l in $list {
		str = $str + $l + $sep
	}

	return $str
}
