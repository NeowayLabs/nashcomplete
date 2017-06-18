#!/usr/bin/env nash

import "./all"

fn wildcardTests() {
	var tmpFiles = (/tmp/a /tmp/aa /tmp/aaa /tmp/aaab /tmp/abaa)

	touch $tmpFiles

	var values <= nash_complete("ls /tmp/a*", "10")

	echo $values
	rm $tmpFiles
}

wildcardTests()
