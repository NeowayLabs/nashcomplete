# check dependencies and download

FZFPATH = $HOME+"/.fzf"

fn getfzf() {
	-test -d $FZFPATH

	if $status != "0" {
		oldpwd <= pwd | tr -d "\n"

		echo "fzf fuzzy finder not installed."
		echo "Installing fzf..."
		cd $HOME
		git clone --depth 1 https://github.com/junegunn/fzf.git .fzf
		./.fzf/install --all >[1=] >[2=]

		chdir($oldpwd)
	}
}

fn checkfzf() {
	-which fzf >[1=] >[2=]

	if $status != "0" {
		getfzf()

		PATH = $PATH+":"+$FZFPATH+"/bin"

		setenv PATH
	}
}

checkfzf()
