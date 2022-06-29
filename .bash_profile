#
#    ~/.bash_profile
#

export EDITOR=nvim
export PATH=$PATH:~/go/bin:~/bin
export CDPATH=.:~/.dotfiles/.config:~/bin

#[[ -f "/$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
[[ -f ~/.bashrc ]] && . ~/.bashrc
