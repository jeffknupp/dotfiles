# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="pygmalion"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
#DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git vi-mode pip svn mercurial)

source $ZSH/oh-my-zsh.sh

alias l='ls -lrt'
PATH=${PATH}:/home/a823222/tools/BIN/
alias vim='gvim'
alias 'd04=ssh cib-tmsd04'
alias 'd01=ssh cib-tmsd01'
alias 'd03=ssh cib-tmsd03'
alias '111=ssh ncibnovap001a.prod.wachovia.net'
alias '111b=ssh ncibnovap001b.prod.wachovia.net'
alias '11a=ssh ncibnovap011a.prod.wachovia.net'
alias '11b=ssh ncibnovap011b.prod.wachovia.net'
alias '444=ssh ncibnovap004a.prod.wachovia.net'
alias '444b=ssh ncibnovap004b.prod.wachovia.net'
alias 'p2a=ssh ncibnovap002a.prod.wachovia.net'
alias 'p2b=ssh ncibnovap002b.prod.wachovia.net'
alias 'pm=ssh  ncib1trmt001.test.wachovia.net'
alias 'p03=ssh cib-tmsp03'
alias 'p05=ssh cib-tmsp05'
alias 'p07=ssh cib-tmsp07'
alias 'p09=ssh cib-tmsp09'
alias 'p11=ssh cib-tmsp10'
alias 'p11=ssh cib-tmsp11'
alias 'p12=ssh cib-tmsp12'
alias 'p13=ssh cib-tmsp13'
alias 'p007=ssh ncib1trmp007.prod.wachovia.net'
alias 'p009=ssh ncib1trmp009.prod.wachovia.net'
alias 'QA=ssh wupra99a0501.wellsfargo.com'
alias 'PTUAT=ssh wupra99a0463.wellsfargo.com'
alias '5b=ssh ncibnovap005b.prod.wachovia.net'
alias 'cctags=cd `project_root.bash`; ctags -R --c++-kinds=+p --fields=+iaS --extra=+q; cd -;'-
alias 'PTA=ssh wppra01a0458.wellsfargo.com'
alias 'PTB=ssh wppra01a0460.wellsfargo.com'
#export LD_LIBRARY_PATH=/home/csidevel/packages/subversion/usr/lib64/:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/home/csidevel/packages/apr-util/1.3.10/lib/:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/home/csidevel/packages/apr/1.4.2/lib/:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/home/csidevel/packages/neon/usr/lib/:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/home/csidevel/packages/subversion/usr/lib64/:$LD_LIBRARY_PATH
#export PATH=/home/csidevel/packages/subversion/usr/bin:$PATH
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/gidevel/packages/cvsnt/2.5.03.2260/lib/rhel5
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/a823222/tools/openssl-0.9.8t/
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/a823222/tools/ncurses/lib
export http_proxy=http://proxy.wellsfargo.com:8080
export https_proxy=http://proxy.wellsfargo.com:8080
export RUBYOPTS=rubygems
export GEM_HOME=/home/a823222/tools/ruby/gems
export PATH=/home/gidevel/packages/ruby/bin/:/home/gidevel/packages/ruby/lib/ruby/gems/1.8/bin/:$PATH
export PATH=$PATH:/home/a148791/local/bin
export TMOUT=0
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/gidevel/packages/gmp/gmp-5.0.1/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/gidevel/packages/mpfr/mpfr-3.0.0/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/gidevel/packages/mpc/mpc-0.8.2/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/a823222/tools/python/lib/
export PATH=/home/gidevel/packages/gcc/bin/:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/gidevel/packages/mpc/mpc-0.8.2/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/gidevel/packages/mpfr/mpfr-3.0.0/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/gidevel/packages/gmp/gmp-5.0.1/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/a823222/tools/libunwind-0.99-beta/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/a823222/tools/curl/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/a823222/tools/readline-lib/lib/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/a823222/tools/bzip2/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/gidevel/packages/sybase/375sybase64/OCS-12_5/lib
export PATH=/home/a823222/tools/doxygen-1.7.5.1/bin/:$PATH
export PATH=/home/a823222/tools/python/bin/:$PATH
export PATH=/home/a823222/tools/python-tip/bin/:$PATH
export PATH=/home/a823222/tools/python3.2/bin/:$PATH
export PATH=/home/gidevel/bin/:$PATH
export PATH=/home/a823222/tools/subversion/bin/:$PATH
export PATH=/home/a823222/tools/swig/bin/:$PATH
export PATH=/home/a823222/tools/scons/bin/:$PATH
export PATH=/home/a823222/tools/go/bin/:$PATH
export PATH=/home/a823222/tools/curl/bin/:$PATH
export PATH=/home/a823222/tools/xmlto/bin/:$PATH
export PATH=/home/a823222/tools/sed/bin/:$PATH
export PATH=/home/a823222/tools/help2man/bin/:$PATH
export PATH=/home/a823222/tools/texinfo/bin/:$PATH
export PATH=/home/a823222/tools/autoconf-2.69/bin/:$PATH
export PATH=/home/a823222/tools/zsh/bin/:/home/a823222/tools/texlive/bin/x86_64-linux:$PATH
export MANPATH=/home/a823222/tools/zsh/share/man/:/home/a823222/tools/texlive/texmf/doc/man:$MANPATH
source /home/a823222/tools/python/bin/virtualenvwrapper.sh
export SYBASE=/nfs/375sybase64/
export SVN_HOST=https://wts-svn.wellsfargo.com/2nov
alias mmv='noglob zmv -W'
