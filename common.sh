# common functions

fn cleanpath() {
	ret <= echo $PATH | sed "s/^://g" | sed "s/:$//g"

	return $ret
}

fn trim(value) {
	value <= echo $value | tr -d "\n"

	return $value
}

fn diffword(complete, line) {
	diff <= echo -n $complete | sed "s#^"+$line+"##g" | tr -d "\n"

	return $diff
}

path  <= cleanpath()
paths <= split($path, ":")

fn getpaths() {
	return $paths
}
