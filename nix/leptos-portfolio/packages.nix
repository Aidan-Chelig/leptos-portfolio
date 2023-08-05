{
  inputs,
  cell,
}: let
  inherit (inputs) std self cells nixpkgs;

  leptosNativeBuildInputs = with nixpkgs; [
    cargo-leptos
    binaryen
    dart-sass
  ];

  commonArgs = {
    src = std.incl self [
      "${self}/Cargo.lock"
      "${self}/Cargo.toml"
      "${self}/src"
      "${self}/assets"
      "${self}/style"
    ];
  };

  name = crane.crateNameFromCargoToml {cargoToml = "${self}/Cargo.toml";};

  #cargoArtifacts = crane.buildDepsOnly (commonArgs
  #  // {
  #    buildPhaseCargoCommand = '' cargo build --package=crane-dummy --bin=leptos_start --target-dir=target/server --no-default-features --features=ssr --release;
  #                                cargo build --package=crane-dummy --lib --target-dir=target/front --target=wasm32-unknown-unknown --no-default-features --features=hydrate --profile=wasm-release'';
  #  });

  leptos-portfolio = crane.buildPackage (commonArgs
    // rec {
      nativeBuildInputs = leptosNativeBuildInputs;
      cargoBuildCommand = "cargo leptos --log wasm --log server build";
      cargoExtraArgs = "--release";
      installPhaseCommand = ''
        mkdir -p $out/bin;
        mkdir -p $out/usr/share;
        mv ./target/server/release/leptos_start $out/bin/
        mv ./target/site/ $out/usr/share/
      '';
      doCheck = false;
      buildPhaseCargoCommand = "${cargoBuildCommand} ${cargoExtraArgs}";
    }
    // {
      #inherit cargoArtifacts;
    });

  crane = inputs.crane.lib.overrideToolchain cells.repo.rust.toolchain;
in {
  #sane default for a binary package

  default = leptos-portfolio;
}
