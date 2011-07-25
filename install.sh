#!/bin/sh

return_dir=`pwd`

echo && echo "Downloading updated pathogen." && echo

cd ~/.vim/autoload/
wget -qN https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

if grep -qEe '(filetype plugin off|call pathogen#infect\(\)|filetype indent on)' ~/.vimrc
then
	echo "Pathogen already in .vimrc. Passing..." && echo
else

	sed -i '1i filetype plugin off\ncall pathogen#infect()\nfiletype indent on' ~/.vimrc
	
	echo "Prepended pathogen init to .vimrc." && echo
fi

cd $return_dir

ret=$?
if [ $ret -ne 0 ]; then
	echo && echo "vim-pathogen failed to install." >&2
else
	 echo && echo "vim-pathogen was installed."
fi

exit $ret
