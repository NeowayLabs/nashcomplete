# check dependencies and download
var FZFPATH = $HOME+"/.fzf"

fn getfzf() {
	_, status <= test -d $FZFPATH

	if $status != "0" {
		var oldpwd <= pwd

		echo "fzf fuzzy finder not installed."
		echo "Installing fzf..."

		chdir($HOME)

		git clone --depth 1 https://github.com/junegunn/fzf.git .fzf
		./.fzf/install --all >[1=] >[2=]

		chdir($oldpwd)
	}
}

fn checkfzf() {
	_, _, status <= which fzf

	if $status != "0" {
		getfzf()

		PATH = $PATH+":"+$FZFPATH+"/bin"

		setenv PATH
	}
}

checkfzf()
