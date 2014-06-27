#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Include stuff that needs to be set before sourcing init.zsh

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source /home/jknupp/tools/powerline/powerline/bindings/zsh/powerline.zsh

# Include machine specific options (i.e. one for work, one for home, one for VPS
# hosts, etc.)
source ~/.zshrc.include

alias l='ls -lrt'
alias mmv='noglob zmv -W'
setopt extended_glob

# Don't exit with error when redirecting to existing file
setopt CLOBBER

# list only directories
alias lsd='ls -1 -d *(/)' 

# Don't try to glob when running 'svn ...'
alias svn='noglob svn'
alias find-exec='noglob find-exec'
alias g='git'
. ~/tools/powerline/powerline/bindings/zsh/powerline.zsh

# Ctrl-R for incremental search in both vi modes
bindkey "^R" history-incremental-search-backward
