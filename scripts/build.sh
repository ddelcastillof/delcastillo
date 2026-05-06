#!/usr/bin/env bash
set -euo pipefail

HEAD="src/head.html"
FOOT="src/foot.html"
OUT="docs/index.html"

# Wraps an EN fragment (and optional ES fragment) in lang-block divs.
# If no .es.html file exists for a section, only the EN block is written.
wrap_pair() {
  local section="$1"
  local en_file="docs/fragments/${section}.html"
  local es_file="docs/fragments/${section}.es.html"

  printf '<div class="lang-block lang-en">\n'
  cat "$en_file"
  printf '</div>\n'

  if [[ -f "$es_file" ]]; then
    printf '<div class="lang-block lang-es" hidden>\n'
    cat "$es_file"
    printf '</div>\n'
  fi
}

{
  cat "$HEAD"
  wrap_pair about
  # Research is EN-only — emit without lang-block wrapper so it stays visible in both languages
  cat "docs/fragments/research.html"
  wrap_pair projects
  wrap_pair blog
  wrap_pair teaching
  cat "$FOOT"
} > "$OUT"

echo "Built $OUT"
