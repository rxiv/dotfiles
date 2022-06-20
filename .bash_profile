#
#    ~/.bash_profile
#

export EDITOR=nvim
export PATH=$PATH:~/go/bin
export CDPATH=.:~/.dotfiles/.config:/usr/local

[[ -f "/$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
[[ -f ~/.bashrc ]] && . ~/.bashrc
