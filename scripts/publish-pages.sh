#!/usr/bin/env bash
# Publish site/ to GitHub Pages for BOTH candidate addresses (Saurabh, 10 Oct: "adhiveshan.aimym.org /
# Kaarwan2.aimym.org ... not decided which one ... host in the GitHub pages and then point these two
# locations to that location"). A Pages site serves ONE custom domain, so each address has its own
# Pages repo with the same files; each gets its own CNAME file. Publishing = force-pushing a fresh
# gh-pages branch (no history) — only on Saurabh's word.
set -euo pipefail
cd "$(dirname "$0")/.."
TARGETS=(
  "Ekapass/cust-aimym-adhiveshan|adhiveshan.aimym.org"
  "Ekapass/cust-aimym-kaarwan2|kaarwan2.aimym.org"
)
SHA=$(git rev-parse --short HEAD 2>/dev/null || echo local)
for t in "${TARGETS[@]}"; do
  repo=${t%%|*}; domain=${t##*|}
  tmp=$(mktemp -d)
  cp -R site/. "$tmp/"
  echo "$domain" > "$tmp/CNAME"
  touch "$tmp/.nojekyll"
  ( cd "$tmp" && git init -q -b gh-pages && git add -A \
      && git -c user.name="Ganesh" -c user.email="saurabh.rungta@gmail.com" commit -qm "Publish $SHA to $domain" \
      && git push -q -f "https://github.com/$repo.git" gh-pages )
  rm -rf "$tmp"
  echo "published $SHA -> $repo (gh-pages) for https://$domain"
done
