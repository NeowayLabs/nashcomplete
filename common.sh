# common functions

IFS = ("\n")

fn cleanpath() {
	ret <= echo $PATH | sed "s/^://g" | sed "s/:$//g"

	return $ret
}

fn trim(value) {
	IFS = ()

	value <= echo $value | tr -d "\n"

	return $value
}

fn diffword(complete, line) {
	IFS = ()

	diff <= echo -n $complete | sed "s#^"+$line+"##g" | tr -d "\n"

	return $diff
}

path  <= cleanpath()
paths <= echo $path | tr ":" "\n"

fn getpaths() {
	return $paths
}
