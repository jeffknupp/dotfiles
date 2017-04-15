#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Include stuff that needs to be set before sourcing init.zsh
fpath=($fpath /usr/local/share/zsh/site-functions)
module_path=($module_path /usr/local/lib/zpython)
fpath+=("/usr/local/share/zsh/site-functions")

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

autoload -U promptinit && promptinit

# antigen package management
source ~/dotfiles/antigen/antigen.zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle psprint/zsh-navigation-tools
#antigen bundle jeffknupp/prezto
antigen bundle command-not-found
#antigen bundle sindresorhus/pure
#antigen bundle kennethreitz/autoenv
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle rupa/z

antigen apply
antigen use prezto

source ~/.zshrc.include

prompt sorin

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

# aliases for searching and installing packages on various systems
# TODO: detect system and use single command to search and install
# that is system agnostic
alias u-install='sudo apt-get install $1'
alias u-search='apt-cache search $1'

alias y-install='sudo yum install $1'
alias y-search='yum search $1'

alias g='git'
alias reload='source ~/.zshrc'

alias meh="echo '¯\_(ツ)_/¯' | tee >(pbcopy)"
alias flipout="echo '(╯°□°）╯︵ ┻━┻' | tee >(pbcopy)"
alias outflip="echo '┬──┬◡ﾉ(° -°ﾉ)' | tee >(pbcopy)"

#source /Users/jknupp/tools/powerline/powerline/bindings/zsh/powerline.zsh

# Ctrl-R for incremental search in both vi modes
bindkey "^R" history-incremental-search-backward

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help
PATH=/usr/local/terraform_0.9.2:/usr/local/terraform_0.9.2:/Applications/Postgres.app/Contents/Versions/latest/bin:/Library/Frameworks/Python.framework/Versions/3.5/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Postgres.app/Contents/Versions/latest/bin:/usr/local/sbin
