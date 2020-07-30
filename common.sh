# common functions

fn cleanpath() {
	var ret <= echo $PATH | sed "s/^://g" | sed "s/:$//g"

	return $ret
}

fn trim(value) {
	var value <= echo $value | tr -d "\n"

	return $value
}

fn diffword(complete, line) {
	var diff <= echo -n $complete | sed "s#^"+$line+"##g" | tr -d "\n"

	return $diff
}

var path <= cleanpath()
var paths <= split($path, ":")

fn getpaths() {
	return $paths
}


fn join(list, sep) {
	var str = ""

	for l in $list {
		str = $str + $l + $sep
	}

	return $str
}
