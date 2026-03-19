#!/usr/bin/env bash
set -euo pipefail

VERSION_FILE="VERSION"
CHANGELOG_FILE="CHANGELOG.md"

die() { echo "Error: $*" >&2; exit 1; }

usage() {
  cat <<EOF
Usage:
  $0 <version>

Examples:
  $0 0.1.0
  $0 v0.1.0

Notes:
- Updates VERSION
- Updates CHANGELOG.md
- Creates a git commit
- Does NOT create git tags
- Does NOT push
EOF
}

normalize_tag() {
  local v="$1"
  v="${v#v}"
  [[ "$v" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "Invalid version '$1' (expected X.Y.Z or vX.Y.Z)"
  echo "v$v"
}

ensure_git_repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "Not a git repository."
}

latest_tag() {
  git describe --tags --abbrev=0 2>/dev/null || true
}

main() {
  [[ $# -eq 1 ]] || { usage; exit 1; }

  ensure_git_repo

  local input_version="$1"
  local new_tag
  new_tag="$(normalize_tag "$input_version")"

  local prev_tag
  prev_tag="$(latest_tag)"

  # Generate changelog
  local changes=""
  if [[ -n "$prev_tag" ]]; then
    changes="$(git log --pretty=format:"- %s" "${prev_tag}..HEAD")"
  else
    changes="$(git log --pretty=format:"- %s")"
  fi

  [[ -n "$changes" ]] || changes="- No notable changes"

  # Write VERSION (bez "v")
  echo "${new_tag#v}" > "$VERSION_FILE"

  # Prepend CHANGELOG
  local date
  date="$(date +%Y-%m-%d)"

  {
    echo "## ${new_tag} (${date})"
    echo
    echo "$changes"
    echo
    if [[ -f "$CHANGELOG_FILE" ]]; then
      cat "$CHANGELOG_FILE"
    fi
  } > .changelog.tmp

  mv .changelog.tmp "$CHANGELOG_FILE"

  # Commit
  git add "$VERSION_FILE" "$CHANGELOG_FILE"
  git commit -m "release: ${new_tag}" -m "${changes}"

  echo "Version bumped to ${new_tag}"
}

main "$@"
