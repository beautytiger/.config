#!/usr/bin/env bash

echo "start working"

textreset=$(tput sgr0) # reset the foreground colour
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3) 


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -d ${DIR}/vimconfig ]
then
    echo "Backing up ${yellow}vimconfig${textreset}."
    mv ${DIR}/vimconfig ${DIR}/vimconfig.original
fi

mkdir ~/.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Cloning vimconfig..."
hash git >/dev/null && /usr/bin/env git clone https://github.com/beautytiger/.config.git ${DIR}/vimconfig || {
  echo "${red}Could not retrieve the vimconfigs! Is git working?${textreset}"
  exit
}

echo "Looking for an existing vimrc config..."
if [ -f ~/.vim/vimrc ] || [ -h ~/.vim/vimrc ]
then
  echo "Found ${yellow}~/.vim/vimrc${textreset}. Backing up to ${yellow}~/.vim/vimrc.original${textreset}";
  mv ~/.vim/vimrc ~/.vim/vimrc.original;
fi

echo "Looking for an existing .vim folder..."
if [ -d ~/.vim ]
then
    echo "Found ${yellow}~/.vim${textreset} folder. Backing up to ${yellow}~/.vim.original${textreset}";
    mv ~/.vim ~/.vim.original;
fi

echo "Creating .vimrc and .vim in homefolder..."
#ln -s ${DIR}/vimconfig/vim ~/.vim
ln -s ${DIR}/vimconfig/vimrc ~/.vim/vimrc
#mkdir ${DIR}/vimconfig/vim/bundle
#git clone https://github.com/gmarik/vundle.git ${DIR}/vimconfig/vim/bundle/vundle
vim +PlugInstall +qall

python3 ~/.vim/plugged/YouCompleteMe/install.py

echo "Done, execute vi/vim to retrieve the vim plugins..."

