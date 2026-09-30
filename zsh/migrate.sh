#!/bin/zsh
#
# One-time zsh cleanup: install the missing CLI tools, retire prezto, point the
# home-directory dotfiles at ~/dotfiles/zsh/, and remove dead leftovers.
#
# Everything it deletes is tarred up first. Run it once:
#
#     zsh ~/dotfiles/zsh/migrate.sh
#
set -u

DOTFILES="$HOME/dotfiles"
STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP="$HOME/zsh-cleanup-backup-$STAMP.tgz"

say() { print -P "%F{cyan}==>%f $*"; }

# ---------------------------------------------------------------------------
# 0. Back up everything this script will remove or replace
# ---------------------------------------------------------------------------
say "Backing up to $BACKUP"
TO_BACKUP=(
  .zshenv .zprofile .zprofile.pysave .zlogin .zlogout .zpreztorc
  .zshrc .zshrc.include .zhrc.bak .zshrc.back.920 .zshrc.bak.1789913256
  .zhistory .z .zsh_plugins.txt .zsh_plugins.zsh .zprezto
)
EXISTING=()
for f in $TO_BACKUP; do
  [[ -e "$HOME/$f" || -L "$HOME/$f" ]] && EXISTING+=("$f")
done
tar -czf "$BACKUP" -C "$HOME" -h $EXISTING 2>/dev/null
[[ -f "$BACKUP" ]] || { print -u2 "Backup failed — stopping."; exit 1; }

# Keep a readable copy of the personal include so it can be folded in later.
[[ -r "$HOME/.zshrc.include" ]] && cp "$HOME/.zshrc.include" "$DOTFILES/zsh/zshrc.include.txt"

# ---------------------------------------------------------------------------
# 1. Install the missing tools
# ---------------------------------------------------------------------------
say "Installing CLI tools"
brew install fzf fd bat zoxide btop git-delta mosh

# Python tooling via uv rather than brew, so it stays pinnable per project.
if (( $+commands[uv] )); then
  say "Installing ruff and ipython with uv"
  uv tool install ruff
  uv tool install ipython
fi

# Not installed on purpose:
#   fnm      — you already have asdf and bun; a fourth node manager invites drift
#   starship — would fight zim's `sorin` prompt; drop `zmodule sorin` first if you want it
#   antidote — unused plugin manager still in brew. To remove: brew uninstall antidote

# ---------------------------------------------------------------------------
# 2. Retire prezto
# ---------------------------------------------------------------------------
say "Removing prezto and its symlinks"
rm -f  "$HOME/.zshenv" "$HOME/.zlogin" "$HOME/.zlogout" "$HOME/.zpreztorc"
rm -rf "$HOME/.zprezto"

# ---------------------------------------------------------------------------
# 3. Point the home dotfiles at ~/dotfiles/zsh/
# ---------------------------------------------------------------------------
say "Linking new zsh files"
rm -f "$HOME/.zshrc" "$HOME/.zprofile"
ln -sfn "$DOTFILES/zsh/zshrc"   "$HOME/.zshrc"
ln -sfn "$DOTFILES/zsh/zshenv"  "$HOME/.zshenv"
ln -sfn "$DOTFILES/zsh/zprofile" "$HOME/.zprofile"
rm -f "$DOTFILES/.zshrc"          # old location, now unused

# ---------------------------------------------------------------------------
# 4. Remove dead leftovers
# ---------------------------------------------------------------------------
say "Removing leftovers"
rm -f "$HOME/.z"                      # rupa/z datafile, from the antigen era
rm -f "$HOME/.zsh_plugins.txt" "$HOME/.zsh_plugins.zsh"   # antidote
rm -f "$HOME/.zhrc.bak" "$HOME/.zshrc.back.920" "$HOME/.zshrc.bak.1789913256"
rm -f "$HOME/.zprofile.pysave"
rm -f "$HOME/.zhistory"               # prezto's old history file (NOT .zsh_history)
rm -f "$HOME/.zcompdump" "$HOME/.zcompdump.dat" "$HOME/.zcompdump.zwc"  # regenerated

# devbox.zsh was written for a Debian VPS (fdfind/batcat, /usr/share/doc/fzf)
# and was never sourced here. Kept in the repo at dotfiles/vps/devbox.zsh.
rm -f "$HOME/.config/zsh/devbox.zsh"

# ---------------------------------------------------------------------------
# 5. Settle zim
# ---------------------------------------------------------------------------
say "Rebuilding zim"
# This script runs non-interactively, so zshrc has not run and these are unset.
# zimfw.zsh reads them from the environment and aborts with
# "zimfw: ZIM_HOME not defined" without them.
export ZIM_HOME="$HOME/.zim"
export ZIM_CONFIG_FILE="$HOME/.config/zsh/zimrc"
source "$HOME/.zim/zimfw.zsh" uninstall      # drops modules no longer in zimrc (asciiship, pure) — answer y
source "$HOME/.zim/zimfw.zsh" build
touch "$HOME/.zim/init.zsh"

# ---------------------------------------------------------------------------
# 6. git: use delta as the pager
# ---------------------------------------------------------------------------
say "Configuring git to use delta"
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global merge.conflictstyle zdiff3

# ---------------------------------------------------------------------------
say "Done. Backup: $BACKUP"
print
print "Start a fresh shell, then check:"
print "  bindkey | grep '\\^R'     # expect fzf-history-widget"
print "  echo \$path | tr ' ' '\\n' # sanity-check PATH"
print
print "Then: exec zsh"
