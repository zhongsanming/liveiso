#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

attr="${1:-.#live}"
dist_dir="${2:-dist}"

echo "Building ${attr}"
out_path="$(nix build "${attr}" --print-out-paths --no-link --extra-experimental-features 'nix-command flakes')"
mkdir -p "${dist_dir}"

mapfile -t isos < <(find "${out_path}" -type f -name '*.iso')
if (( ${#isos[@]} == 0 )); then
  echo "No ISO files found under ${out_path}" >&2
  exit 1
fi

for iso in "${isos[@]}"; do
  cp -v "${iso}" "${dist_dir}/"
done

ls -lh "${dist_dir}"
