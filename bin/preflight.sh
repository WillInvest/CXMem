#!/usr/bin/env bash
set -u

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 2
}

if [ ! -d "${repo_root}/.git" ]; then
  fail '${HOME}/CXMem/ is not a git repository'
fi

branch="$(git -C "${repo_root}" branch --show-current 2>/dev/null || true)"
if [ "${branch}" != "main" ]; then
  fail "not on main (current: ${branch}); switch manually"
fi

if [ -n "$(git -C "${repo_root}" status --porcelain)" ]; then
  fail "working tree dirty; commit or stash before scaffolding"
fi

printf 'ok\n'
