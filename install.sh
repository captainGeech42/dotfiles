#!/bin/bash

# https://blog.ssdnodes.com/blog/tutorial-lets-make-development-lives-better-dotfiles/

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "[~] oh-my-zsh not installed, installing..."
	
	#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
	echo "[~] oh-my-zsh already installed, skipping..."
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
ln -sf "$DOTFILES_DIR/.ssh_config" ~/.ssh/config
