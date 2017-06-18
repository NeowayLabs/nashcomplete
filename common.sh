# common functions

fn cleanpath() {
	var ret <= echo $PATH | sed "s/^://g" | sed "s/:$//g"

	return $ret
}

fn trim(value) {
	value <= echo -n $value

	return $value
}

fn diffword(complete, line) {
	diff <= echo -n $complete | sed "s#^"+$line+"##g"

	return $diff
}

var path  <= cleanpath()
var paths <= split($path, ":")

fn getpaths() {
	return $paths
}
