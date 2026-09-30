#!/bin/zsh
#
# Read-only disk survey. Deletes NOTHING — it only measures.
#
#     zsh ~/dotfiles/scan-disk.sh
#
# Writes: ~/dotfiles/diskscan.txt
# Takes a few minutes: it walks your whole home directory once.
#
set -u
out="$HOME/dotfiles/diskscan.txt"
: > "$out"
exec 3>&1 1>"$out" 2>&1

print "=== Volume ==="
df -h / /System/Volumes/Data 2>/dev/null

print "\n=== APFS local snapshots (often GBs of 'purgeable' space) ==="
tmutil listlocalsnapshots / 2>/dev/null || print "none / not available"

print "\n=== Home, top level (sorted) ==="
du -sxh $HOME/*(N) $HOME/.*(N/) 2>/dev/null | sort -rh | head -40

print "\n=== ~/Library, top level ==="
du -sxh $HOME/Library/*(N) 2>/dev/null | sort -rh | head -20

print "\n=== ~/Library/Caches ==="
du -sxh $HOME/Library/Caches/*(N) 2>/dev/null | sort -rh | head -20

print "\n=== Known dev caches ==="
for d in $HOME/.cache $HOME/Library/Caches/Homebrew $HOME/.npm $HOME/.cargo/registry \
         $HOME/.rustup/toolchains $HOME/code/go/pkg/mod $HOME/go/pkg/mod \
         $HOME/.ollama $HOME/.cache/uv $HOME/Library/pnpm $HOME/Library/Caches/pnpm \
         $HOME/.bun/install/cache "$HOME/Library/Developer/Xcode/DerivedData" \
         "$HOME/Library/Developer/Xcode/iOS DeviceSupport" \
         "$HOME/Library/Developer/CoreSimulator" \
         "$HOME/Library/Containers/com.docker.docker" "$HOME/.docker" \
         "$HOME/VirtualBox VMs" $HOME/.Trash; do
  [[ -e $d ]] && du -sxh "$d" 2>/dev/null
done | sort -rh

print "\n=== brew ==="
bc=$(brew --cache 2>/dev/null); [[ -n $bc && -e $bc ]] && du -sh "$bc" 2>/dev/null
print "outdated formulae: $(brew outdated --quiet 2>/dev/null | wc -l | tr -d ' ')"

print "\n=== docker (if running) ==="
docker system df 2>/dev/null || print "docker not running"

print "\n=== node_modules directories over 100MB ==="
find $HOME -type d -name node_modules -prune -print0 2>/dev/null \
  | xargs -0 -I{} du -sxm {} 2>/dev/null | awk '$1>100' | sort -rn | head -20

print "\n=== individual files over 1GB ==="
find $HOME -type f -size +1G 2>/dev/null -exec ls -lh {} \; | awk '{print $5"\t"$9}' | head -30

exec 1>&3
print "done -> $out"
