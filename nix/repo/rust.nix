# export fenix toolchain as its own package set
{
  inputs,
  cell,
}: let
  inherit (inputs) fenix;

  # you may change "default" to any of "[minimal|default|complete|latest]" for variants
  # see upstream fenix documentation for details
  rustPkgs = builtins.removeAttrs fenix.packages.latest ["withComponents" "name" "type"];
in
  #add rust-analyzer from nightly, if not present
  #if rustPkgs ? rust-analyzer
  #then rustPkgs
  #else
  rustPkgs
  // {
    inherit (fenix.packages) rust-analyzer;
    toolchain = fenix.packages.combine [
      (builtins.attrValues rustPkgs)
      fenix.packages.rust-analyzer
      fenix.packages.targets.wasm32-unknown-unknown.latest.rust-std
    ];
  }
