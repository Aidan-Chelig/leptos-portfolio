{
  inputs,
  cell,
}: let
  inherit (inputs) std self cells nixpkgs;

  crane = inputs.crane.lib.overrideToolchain cells.repo.rust.toolchain;
in {
  # sane default for a binary package
  # default = crane.buildPackage {
  #   src = std.incl self [
  #     "${self}/Cargo.lock"
  #     "${self}/Cargo.toml"
  #     "${self}/src"
  #   ];
  # };

  default = nixpkgs.rustPlatform.buildRustPackage rec {
    pname = "foo-bar";
    version = "0.1";
    cargoLock.lockFile = "${self}/Cargo.lock";
    src = std.incl self [
      "${self}/Cargo.lock"
      "${self}/Cargo.toml"
      "${self}/src"
    ];
  };
}
