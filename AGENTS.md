# Repository guide

This repository contains declarative dotfiles and system configuration built
with Nix flakes. It is the public, reusable foundation for multiple machines.

## Goals

- Support macOS machines with nix-darwin and Home Manager.
- Support non-NixOS Linux machines with Home Manager.
- Share portable user configuration across platforms.
- Keep platform and host differences explicit.
- Export reusable modules that a separate private work configuration can import.
- Grow incrementally: do not introduce directories or abstractions before they
  have a concrete use.

## Intended structure

The repository should evolve toward this layout as features and hosts are
introduced:

```text
.
├── flake.nix
├── modules/
│   ├── home/
│   │   ├── common.nix
│   │   └── programs/
│   └── darwin/
└── hosts/
    └── <hostname>/
        ├── default.nix
        └── home.nix
```

## Module boundaries

- `modules/home/` contains reusable Home Manager modules.
- Cross-platform user configuration belongs under `modules/home/` and should
  work on both macOS and Linux.
- `modules/<system>/` contains reusable configuration for a specific system
  (e.g: `darwin`, or `linux`).
- `hosts/<hostname>/` contains facts and choices specific to one machine, such
  as its architecture, username, enabled capabilities, and local overrides.
- A module should normally represent a coherent capability or program. Hosts
  compose modules instead of duplicating their implementation.
- Prefer platform-specific modules over widespread platform conditionals in
  shared modules.
- Flakes assemble complete configurations; modules provide reusable
  configuration.

## Public and private configuration

This public flake should export useful Home Manager and nix-darwin modules. A
separate private flake can consume this repository as an input, import those
public modules, and add private host modules.

Private configuration is not the same as secret storage. Never place passwords,
tokens, private keys, or other secret values directly in Nix expressions because
evaluated values can be copied into the Nix store. Use an appropriate secret
manager, such as macOS Keychain, sops-nix, or agenix, when secrets are needed.

## Conventions

- Sort lists alphabetically when their order has no semantic meaning,
  especially lists of tools, packages, and commands.
- Use explicit hostnames, usernames, and target systems at the host assembly
  boundary.
- Keep shared defaults conservative and allow hosts to opt into capabilities.
- Set Home Manager and nix-darwin state versions deliberately. Do not bump a
  state version merely because a newer release exists.
- Keep `nixpkgs`, nix-darwin, and Home Manager inputs aligned by making related
  inputs follow the flake's `nixpkgs` input.
- Prefer small, understandable modules and descriptive names over premature
  helper functions or framework-like abstractions.
- Format Nix files consistently with two-space indentation.
- After a change, evaluate the affected flake outputs rather than relying only
  on syntax checks or `nix flake check`.
