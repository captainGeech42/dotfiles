#!/bin/bash

# https://blog.ssdnodes.com/blog/tutorial-lets-make-development-lives-better-dotfiles/

# Install pre-reqs (only works on debian-based)
sudo apt install -y powerline zsh tmux curl

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	if [ ! -f "/usr/bin/zsh" ]; then
		echo "[~] zsh not installed, skipping oh-my-zsh"
	else
		echo "[~] oh-my-zsh not installed, installing..."
		
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	fi
else
	echo "[~] oh-my-zsh already installed, skipping..."
fi

# Install gdb-peda
if [ ! -d "$HOME/.peda" ]; then
	echo "[~] gdb-peda not installed, installing..."

	git clone https://github.com/longld/peda.git ~/.peda
else
	echo "[~] gdb-peda already installed, skipping..."
fi

# Get dotfiles installation directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Generate symlinks
echo "[~] generating symlinks..."

ln -sf "$DOTFILES_DIR/.gitconfig" ~
ln -sf "$DOTFILES_DIR/.gitignore" ~
ln -sf "$DOTFILES_DIR/.zshrc" ~
ln -sf "$DOTFILES_DIR/.exports" ~
ln -sf "$DOTFILES_DIR/.aliases" ~
ln -sf "$DOTFILES_DIR/.tmux.conf" ~
mkdir -p ~/.ssh 2>/dev/null
ln -sf "$DOTFILES_DIR/.ssh/config" ~/.ssh/config
ln -sf "$DOTFILES_DIR/.gdbinit" ~
ln -sf "$DOTFILES_DIR/.vimrc" ~
