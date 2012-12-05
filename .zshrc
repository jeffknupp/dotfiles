#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Include stuff that needs to be set before sourcing init.zsh
source .zshrc.pre

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Include machine specific options (i.e. one for work, one for home, one for VPS
# hosts, etc.)
source .zshrc.include

alias l='ls -lrt'
alias vim='gvim'
alias mmv='noglob zmv -W'
setopt extended_glob
alias lsd='ls -1 -d *(/)' # list only directories
# Ctrl-R for incremental search in both vi modes
bindkey "^R" history-incremental-search-backward
