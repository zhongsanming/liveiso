# Live ISO

A small Nix flake for building a customizable NixOS live ISO.

## Usage

Build the default live ISO:

```console
nix build .#live -o result
```

Build the installer ISO:

```console
nix build .#installer -o result-installer
```

The generated ISO is written below `result`; the exact layout can vary, so use
`scripts/build-and-collect.sh` when you need a flat `dist/` directory for CI
artifacts.

Run `nix flake lock` once and commit `flake.lock` so future builds and CI runs
use the same dependency revisions.

## Configuration

Edit `hosts/live.nix` to add packages, users, SSH keys, filesystem support, or
other NixOS options. The file starts from the official minimal installation CD
module, so it remains useful for installing NixOS from the booted ISO.

## Artifact Build Script

`scripts/build-and-collect.sh` builds an ISO and copies every generated `.iso`
file into `dist/`:

```console
bash scripts/build-and-collect.sh .#live dist
```

This keeps the CI workflows independent of nixos-generators output layout.

## CI/CD

The repository includes these build-and-upload paths:

- `.github/workflows/build.yml`: GitHub Actions artifact upload on pushes and
  pull requests, plus a GitHub release for `v*` tags.
- `.gitlab-ci.yml`: GitLab CI artifact upload with a configurable expiration.
- `.forgejo/workflows/build.yml`: Forgejo/Gitea Actions artifact upload.

For Gitea, move `.forgejo/workflows/build.yml` to `.gitea/workflows/build.yml`
or use a repository where Forgejo-style Actions are enabled.
