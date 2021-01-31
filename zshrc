export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="ys-py"

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"

ZSH_CUSTOM="$HOME/.dotfiles/zsh-custom"

plugins=(git colored-man-pages virtualenv vi-mode)

source $ZSH/oh-my-zsh.sh

source ~/.exports
source ~/.aliases

source ~/venv/py3/bin/activate

if [ "$TMUX" = "" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
	tmux new-session
fi
