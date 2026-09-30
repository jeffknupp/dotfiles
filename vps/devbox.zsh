#
# ~/.zshrc.include -> dotfiles/vps/devbox.zsh
#
# Linux-only additions to zsh/zshrc, which sources ~/.zshrc.include near its
# end (after zim, before history). Everything else - PATH basics, zim, fzf,
# zoxide, direnv, aliases, history - is zshrc's job, and this file must not
# redo it: the previous devbox.zsh ran its own compinit, prompt and plugins on
# top of zim, and re-ran fzf, zoxide and direnv.
#

# Tools the Mac gets from Homebrew live elsewhere here. Entries that do not
# exist are dropped, as zshrc does for its own list.
path=(
  "$HOME/.local/share/fnm"
  /usr/local/go/bin
  $path
)
path=(${^path}(N-/))

# Node via fnm (the Mac uses asdf/bun). --use-on-cd follows .node-version files.
(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd --shell zsh)"

# zshrc's meh/flipout/outflip pipe to pbcopy. Over ssh, OSC 52 sends the text
# through the terminal to the local clipboard (tmux needs set-clipboard on).
(( $+commands[pbcopy] )) || pbcopy() { printf '\033]52;c;%s\a' "$(base64 | tr -d '\n')"; }

# zshenv sets BROWSER=open, which is a macOS command.
[[ ${BROWSER:-} == open ]] && (( ! $+commands[open] )) && unset BROWSER
