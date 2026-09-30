#!/bin/zsh
#
# Start nvim headless on one scratch file per language, give the language
# servers a few seconds to attach, and save the LSP health report.
#
#     zsh ~/dotfiles/vim/lsp-check.sh
#
# Report: ~/dotfiles/vim/lsp-health.txt
#
set -u
scratch=$(mktemp -d)
cd "$scratch" || exit 1
for e in py go rs ts lua; do : > "lspcheck.$e"; done

out="$HOME/dotfiles/vim/lsp-health.txt"

# The tsc LSP needs TypeScript 7+ (native compiler with `--lsp`).
if (( $+commands[tsc] )); then
  ver=$(tsc --version 2>/dev/null | awk '{print $NF}')
  print "tsc:        ${commands[tsc]}  (version ${ver:-unknown})"
  (( ${${(s:.:)ver}[1]:-0} >= 7 )) && print "  lsp:      supported (tsc --lsp)" \
                                    || print "  lsp:      NOT supported — needs TypeScript 7+"
else
  print "tsc:        NOT ON PATH  ->  brew install typescript"
fi
print
nvim --headless lspcheck.{py,go,rs,ts,lua} \
  "+argdo edit" "+sleep 5" \
  "+checkhealth vim.lsp" "+w! $out" +qa

print "\nSaved: $out"
grep -E 'ERROR|WARNING|^- [a-z_]+ \(id:' "$out" | sed 's/^/  /'
