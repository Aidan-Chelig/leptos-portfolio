{
  description = "A very basic flake for Rust development";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  inputs = {
    std.url = "github:divnix/std";
    std.inputs.devshell.follows = "devshell";
    std.inputs.nixago.follows = "nixago";
    std.inputs.n2c.follows = "n2c";
  };
  inputs.devshell.url = "github:numtide/devshell";
  inputs.nixago.url = "github:nix-community/nixago";
  inputs.nixago.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixpkgs.follows = "std/nixpkgs";
  inputs.nixfmt.url = "github:serokell/nixfmt/?ref=refs/pull/118/head";
  inputs.nixfmt.inputs.nixpkgs.follows = "nixpkgs";
  inputs.call-flake.url = "github:divnix/call-flake";
  inputs.n2c.url = "github:nlewo/nix2container";

  inputs.fenix.url = "github:nix-community/fenix";
  inputs.crane.url = "github:ipetkov/crane";
  inputs.crane.inputs.nixpkgs.follows = "nixpkgs";
  inputs.crane.inputs.flake-compat.follows = "";
  inputs.crane.inputs.rust-overlay.follows = "";

  outputs = {
    self,
    std,
    ...
  } @ inputs:
    std.growOn
    {
      inherit inputs;
      systems = ["x86_64-linux" "aarch64-linux"];
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes; [
        (pkgs "rust")
        (installables "packages")
        # Contribution Environment
        (nixago "configs")
        (devshells "shells")
        (runnables "operables")
        (installables "generate")
        (containers "containers")
      ];
    }
    {
      devShells = std.harvest self ["repo" "shells"];
      packages = std.harvest self ["leptos_porfolio" "packages" "repo" "generate"];
      containers = std.harvest self ["leptos_portfolio" "containers"];
    };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
