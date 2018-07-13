# check dependencies and download
var FZFPATH = $HOME+"/.fzf"

fn getfzf() {
	var _, status <= test -d $FZFPATH

	if $status != "0" {
		var oldpwd <= pwd | tr -d "\n"
		
		echo "fzf fuzzy finder not installed."
		echo "Installing fzf..."
		
		chdir($HOME)
		
		git clone --depth 1 https://github.com/junegunn/fzf.git .fzf
		./.fzf/install --all >[1=] >[2=]
		
		chdir($oldpwd)
	}
}

fn checkfzf() {
	var _, status <= which fzf >[1=] >[2=]

	if $status != "0" {
		getfzf()
		
		var PATH = $PATH+":"+$FZFPATH+"/bin"
		
		setenv PATH
	}
}

checkfzf()
