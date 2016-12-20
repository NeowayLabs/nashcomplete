#!/usr/bin/env nash

import "./all"

fn fileTests() {
	tmpFiles = (/tmp/a /tmp/aa /tmp/aaa /tmp/aaab /tmp/abaa)

	touch $tmpFiles

	values <= nash_complete("ls /tmp/a*", "10")

	echo $values
	rm $tmpFiles
}

fileTests()
