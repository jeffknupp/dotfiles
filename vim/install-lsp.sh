#!/bin/zsh
#
# Language servers and formatters for the neovim config in ~/.config/nvim.
#
#     zsh ~/dotfiles/vim/install-lsp.sh
#
# Deliberately not using mason.nvim: these go in with the package managers you
# already run, so nvim uses the same binaries your shell does and there's no
# second copy to keep updated. Safe to re-run — everything is skipped if
# already present.
#
set -u

have() { (( $+commands[$1] )) }
say()  { print -P "%F{cyan}==>%f $*" }
skip() { print -P "%F{242}    already installed: $1%f" }

# --- Make sure ~/.vimrc is the repo copy ----------------------------------
# ~/.zshrc was a symlink into ~/dotfiles; ~/.vimrc may or may not be. If it is
# a separate file, the cleaned-up version in the repo would never be read.
VIMRC_REPO="$HOME/dotfiles/.vimrc"
VIMRC_HOME="$HOME/.vimrc"
if [[ -L "$VIMRC_HOME" && "${VIMRC_HOME:A}" == "${VIMRC_REPO:A}" ]]; then
  skip "~/.vimrc -> dotfiles/.vimrc"
elif [[ -e "$HOME/.vimrc" || -L "$HOME/.vimrc" ]]; then
  say "~/.vimrc is not the repo copy — backing it up and linking"
  mv "$VIMRC_HOME" "$HOME/.vimrc.before-cleanup-$(date +%Y%m%d-%H%M%S)"
  ln -sfn "$VIMRC_REPO" "$VIMRC_HOME"
else
  say "linking ~/.vimrc -> dotfiles/.vimrc"
  ln -sfn "$VIMRC_REPO" "$HOME/.vimrc"
fi

# --- Python: pyright (types) + ruff (lint, import sort, format) ------------
if have pyright-langserver || have pyright; then skip pyright; else
  say "pyright"; brew install pyright
fi
if have ruff; then skip ruff; else
  say "ruff"; have uv && uv tool install ruff || brew install ruff
fi

# --- Go: gopls + goimports -------------------------------------------------
# This script runs non-interactively, so zshrc's GOPATH is NOT set here and
# `go install` would silently default to ~/go/bin — which isn't on your PATH.
export GOPATH="${GOPATH:-$HOME/code/go}"
mkdir -p "$GOPATH/bin"
path=("$GOPATH/bin" $path)
if have go; then
  if have gopls; then skip gopls; else
    say "gopls"; go install golang.org/x/tools/gopls@latest
  fi
  if have goimports; then skip goimports; else
    say "goimports"; go install golang.org/x/tools/cmd/goimports@latest
  fi
else
  print -u2 "    go not found — skipping gopls/goimports"
fi

# --- Rust: rust-analyzer + rustfmt ----------------------------------------
if have rustup; then
  say "rust-analyzer + rustfmt (rustup components)"
  rustup component add rust-analyzer rustfmt
elif have rust-analyzer; then
  skip rust-analyzer
else
  print -u2 "    rustup not found — install rust-analyzer manually if you want Rust LSP"
fi

# --- TypeScript / JavaScript ----------------------------------------------
# TypeScript 7+ ships its language server inside `tsc` itself (tsc --lsp).
# typescript-language-server is NOT needed and cannot work with TS 7: it wraps
# tsserver.js, which the native compiler no longer includes.
if brew list typescript >/dev/null 2>&1; then skip typescript; else
  say "typescript"; brew install typescript
fi
if have tsc; then
  ts_major=${${(s:.:)$(tsc --version 2>/dev/null | awk '{print $NF}')}[1]}
  if (( ${ts_major:-0} < 7 )); then
    print -u2 "    tsc on PATH is ${ts_major:-unknown}.x — the nvim LSP needs 7.0+: brew upgrade typescript"
  fi
fi

# --- Lua (for editing this config) ----------------------------------------
if have lua-language-server; then skip lua-language-server; else
  say "lua-language-server"; brew install lua-language-server
fi

# --- Formatters conform.nvim expects --------------------------------------
if have stylua; then skip stylua; else say "stylua"; brew install stylua; fi
if have prettier; then skip prettier; else say "prettier"; brew install prettier; fi

print
say "Checking what nvim will find on PATH"
for b in pyright-langserver ruff gopls goimports rust-analyzer rustfmt \
         tsc lua-language-server stylua prettier; do
  if have $b; then
    print -P "  %F{green}ok%f    $b  ($(command -v $b))"
  else
    print -P "  %F{red}MISSING%f $b"
  fi
done
print
print "Then open nvim: lazy.nvim installs the plugins on first start."
print "Check health afterwards with:  :checkhealth  and  :LspInfo"
