# dot.nix

Declarative system configuration and dotfiles built with Nix flakes. This is
the public, reusable foundation for macOS machines managed with nix-darwin and
Home Manager, and for non-NixOS Linux machines managed with Home Manager.

The repository currently defines the `muthur` Apple Silicon macOS host for the
`iluengo` user. It configures macOS defaults, Home Manager, and a small set of
user programs, including AeroSpace, Codex, Ghostty, and Neovim.

## Layout

```text
.
├── flake.nix
├── modules/
│   ├── darwin/             # reusable macOS configuration
│   └── home/               # reusable Home Manager configuration
│       └── programs/       # individual program capabilities
└── hosts/
    └── muthur/             # host-specific facts and module selection
```

`modules/` holds portable, reusable capabilities. `hosts/` holds decisions
specific to a machine, such as its hostname, architecture, username, and which
modules it enables.

## Applying the macOS configuration

After Nix and nix-darwin have been bootstrapped on the machine, apply the
configuration from the repository root with:

```sh
darwin-rebuild switch --flake .#<flake-name>
```

To evaluate the system derivation without activating it:

```sh
nix eval .#darwinConfigurations.muthur.config.system.build.toplevel.drvPath
```

On a non-NixOS Linux machine, activate a standalone Home Manager
configuration with:

```sh
home-manager switch --flake .#<flake-name>
```

## Extending the configuration

Add cross-platform user capabilities as Home Manager modules under
`modules/home/`, normally with one module per program or coherent capability.
Import those modules from a host's `home.nix`. Keep macOS-only behavior in
`modules/darwin/`, and keep host facts and choices in `hosts/<hostname>/`.

When adding a host, expose its completed configuration from `flake.nix` and
set Home Manager and nix-darwin state versions deliberately. Evaluate the
affected flake output after each change.

## Public and private configuration

This flake is intended to be usable as an input to a separate private
configuration repository. Private host modules can import the public modules
and compose them with work- or machine-specific configuration.

Do not put passwords, tokens, private keys, or other secrets in Nix files:
evaluated values can be copied into the Nix store. Use a suitable secret
manager instead, such as macOS Keychain, sops-nix, or agenix.
