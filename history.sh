# history autocomplete

fn nash_complete_history() {
	var choice, status <= (
		cat $NASHPATH+"/history" |
		sort -u |
		fzf -0
		--header
		"History search" --prompt "(λ history)>" --reverse
	)

	if $status != "0" {
		return ()
	}

	choice <= trim($choice)

	return ($choice "0")
}
