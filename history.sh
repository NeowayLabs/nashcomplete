# history autocomplete

fn nash_complete_history() {
	ret    = ()

	choice <= (
		cat $NASHPATH+"/history" |
		sort -u |
		-fzf -0
		--header
		"History search" --prompt "(λ history)>" --reverse
	)

	if $status != "0" {
		return $ret
	}

	choice <= trim($choice)

	ret = ($choice "0")

	return $ret
}
