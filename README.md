# nashcomplete

The name says everything.

[![asciicast](https://asciinema.org/a/enr2mrchewlezfproraoh4gdy.png)](https://asciinema.org/a/enr2mrchewlezfproraoh4gdy?autoplay=true&speed=1.5)

## Installation

First clone the repository:

```sh
λ> mkdir -p $NASHPATH+"/lib"
λ> cd $NASHPATH+"/lib"
λ> git clone git@github.com:tiago4orion/nashcomplete.git
```

To setup the auto complete you only need to add an import line into your init script.

```sh
# ~/.nash/init

import nashcomplete/all

```

Done.

## Adding your own completions

There's a way to add your own completion to some command:
Nashcomplete looks for a list of completion callbacks, that you can extend with your own completions.

The example below adds a simple completion for `docker` subcommands.

```sh
# my completes
# ~/.nash/conf/complete

import "nashcomplete/all"

# The `parts` argument hold the line splited by space.
fn docker_complete(parts, line, pos) {
	IFS    = ()
	ret    = ()

	partsz <= len($parts)

	if $partsz != "1" {
		# only autocomplete the subcommand
		return $ret
	}

	choice <= (
		echo "attach build commit cp create diff events exec export history images import info inspect kill load login logout logs network node pause port ps pull push rename restart rm rmi run save search service start stats stop swarm tag top unpause update version volume wait" |
		tr " " "\n" |
		-fzf --header "Docker subcommands: "
						--reverse
						 |
		tr -d "\n"
	)

	if $status != "0" {
		return $ret
	}

	ret = ($choice+" " "0")

	return $ret
}

dockercomplete = ("docker" $docker_complete)

NASHCOMPLETE_CMD <= append($NASHCOMPLETE_CMD, $dockercomplete)
```
