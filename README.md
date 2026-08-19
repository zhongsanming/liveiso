# Live ISO

A small Nix flake for building a customizable NixOS live ISO.

## Usage

Build the default live ISO:

```console
nix build .#live -o result
```

The generated ISO is written below `result/iso/`. Flash the ISO to a USB stick
and boot it on the target machine.

Run `nix flake lock` once and commit `flake.lock` so future builds and CI runs
use the same dependency revisions.

## Configuration

Edit the `liveModule` section in `flake.nix` to add packages, users, SSH keys,
filesystem support, or other NixOS options. It starts from the official minimal
installation CD module, so it remains useful for installing NixOS from the
booted ISO.

## CI/CD

The repository includes these build-and-upload paths:

- `.github/workflows/build.yml`: GitHub Actions artifact upload on pushes and
  pull requests, plus a GitHub release for `v*` tags.
- `.gitlab-ci.yml`: GitLab CI artifact upload with a configurable expiration.
- `.forgejo/workflows/build.yml`: Forgejo/Gitea Actions artifact upload.

For Gitea, move `.forgejo/workflows/build.yml` to `.gitea/workflows/build.yml`
or use a repository where Forgejo-style Actions are enabled.
