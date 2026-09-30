# ─── devbox.zsh ──────────────────────────────────────────────────────────────
# Machine-specific configuration for this box.
#
# Source this from the END of your .zshrc, after any framework has loaded:
#     source "$HOME/.config/zsh/devbox.zsh"
#
# It deliberately does NOT touch completion, the prompt, or plugins when a zsh
# framework is present — those belong to the framework. It also never clobbers
# an alias or export you have already defined.

# ── Framework detection ──────────────────────────────────────────────────────
# Checked on disk as well as by variable, so this works whether devbox.zsh is
# sourced before or after the framework initialises.
_devbox_framework=""
if [[ -n "${ZIM_HOME:-}" || -e "${ZDOTDIR:-$HOME}/.zimrc" || -e "$HOME/.zim" ]]; then
  _devbox_framework="zim"
elif [[ -n "${ZSH:-}" && -e "${ZSH:-}/oh-my-zsh.sh" ]]; then
  _devbox_framework="oh-my-zsh"
elif [[ -n "${ZPREZTODIR:-}" || -e "$HOME/.zprezto" ]]; then
  _devbox_framework="prezto"
fi

# ── PATH ─────────────────────────────────────────────────────────────────────
# typeset -U dedupes, so this is safe no matter how many times it runs.
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/.local/share/fnm"
  /usr/local/go/bin
  "$HOME/go/bin"
  $path
)
export PATH

# ── Environment (only if you have not set it yourself) ───────────────────────
: "${EDITOR:=nvim}"; : "${VISUAL:=nvim}"; : "${PAGER:=less}"
export EDITOR VISUAL PAGER
[[ -z "${LESS:-}" ]] && export LESS='-R -F -X -i -M'
command -v batcat >/dev/null && [[ -z "${MANPAGER:-}" ]] && \
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

# ── Completion, prompt, plugins: ONLY when no framework owns them ────────────
if [[ -z "$_devbox_framework" ]]; then

  setopt EXTENDED_GLOB
  fpath=("$HOME/.config/zsh/zsh-completions/src" $fpath)
  autoload -Uz compinit

  # Rebuild the dump at most once a day; -C skips the security check otherwise.
  _zcd="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -n ${_zcd}(#qN.mh+24) ]] || [[ ! -s "$_zcd" ]]; then
    compinit -d "$_zcd"
  else
    compinit -C -d "$_zcd"
  fi
  unset _zcd

  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
  zstyle ':completion:*' menu select
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
  zstyle ':completion:*' group-name ''

  # History and shell options — a framework normally sets its own
  HISTFILE="$HOME/.zsh_history"
  HISTSIZE=200000
  SAVEHIST=200000
  setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE
  setopt HIST_REDUCE_BLANKS HIST_VERIFY EXTENDED_HISTORY INC_APPEND_HISTORY
  setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
  setopt INTERACTIVE_COMMENTS NO_BEEP GLOB_DOTS

  bindkey -e
  bindkey '^[[A' history-search-backward
  bindkey '^[[B' history-search-forward
  bindkey '^[[1;5C' forward-word
  bindkey '^[[1;5D' backward-word
  WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

  # Prompt
  command -v starship >/dev/null && eval "$(starship init zsh)"

  # Plugins — syntax highlighting must be sourced last
  [[ -f "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  [[ -f "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

fi

# ── Aliases — defined only where you do not already have one ─────────────────
_dba() { alias "$1" >/dev/null 2>&1 || alias "$1"="$2"; }

command -v eza >/dev/null && {
  _dba ls  'eza --group-directories-first'
  _dba ll  'eza -lh --group-directories-first --git'
  _dba la  'eza -lha --group-directories-first --git'
  _dba lt  'eza --tree --level=2 --group-directories-first'
}
command -v batcat >/dev/null && _dba cat 'batcat --paging=never'
command -v btop   >/dev/null && _dba top 'btop'
command -v duf    >/dev/null && _dba df  'duf'
command -v nvim   >/dev/null && { _dba vim 'nvim'; _dba v 'nvim'; }

_dba gs  'git status -sb'
_dba gd  'git diff'
_dba gds 'git diff --staged'
_dba gl  'git log --oneline --graph --decorate -20'

_dba dc  'docker compose'
_dba dps 'docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
_dba dsh 'docker exec -it'

_dba venv 'uv venv && source .venv/bin/activate'
_dba big  'du -ah . 2>/dev/null | sort -rh | head -10'
_dba mem  'ps aux --sort=-%mem | head -11'

unset -f _dba

# ── Functions (skipped if you already define one by that name) ───────────────
(( $+functions[mkcd] )) || mkcd() { mkdir -p "$1" && cd "$1"; }

(( $+functions[extract] )) || extract() {
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;  *.tar.gz) tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;  *.tar)    tar xf  "$1" ;;
    *.bz2)     bunzip2 "$1" ;;  *.gz)     gunzip  "$1" ;;
    *.zip)     unzip   "$1" ;;  *.7z)     7z x    "$1" ;;
    *) echo "extract: don't know how to handle '$1'" ;;
  esac
}

(( $+functions[fkill] )) || fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m --header='select process(es) to kill' | awk '{print $2}')
  [[ -n "$pid" ]] && echo "$pid" | xargs kill -"${1:-9}"
}

# ── Tool hooks — these run last so a framework cannot stomp them ─────────────
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v direnv >/dev/null && eval "$(direnv hook zsh)"
[[ -x "$HOME/.local/share/fnm/fnm" ]] && eval "$("$HOME/.local/share/fnm/fnm" env --use-on-cd)"

# fzf: Debian ships these under /usr/share/doc
if [[ -z "${FZF_DEFAULT_COMMAND:-}" ]]; then
  [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && \
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && \
    source /usr/share/doc/fzf/examples/completion.zsh
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
fi

unset _devbox_framework
