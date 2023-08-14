{
  inputs,
  cell,
}: let
  inherit (inputs) std self cells nixpkgs;

  l = nixpkgs.lib // builtins;

  leptosNativeBuildInputs = with nixpkgs; [
    cargo-leptos
    binaryen
    dart-sass
    openssl
    pkg-config
  ];

  commonArgs = {
    src = lib.cleanSourceWith {
      src = ./.; # The original, unfiltered source
      filter = path: type:
        (l.hasSuffix "\.html" path)
        || (l.hasSuffix "\.scss" path)
        ||
        # Example of a folder for images, icons, etc
        (l.hasInfix "/assets/" path)
        ||
        # Default filter from crane (allow .rs files)
        (crane.filterCargoSources path type);
    };
  };

  # TODO  get this working!!!!
  cargoArtifacts = crane.buildDepsOnly (commonArgs
    // {
      cargoExtraArgs = "--profile release";
    });

  leptos_portfolio_ssr = crane.buildPackage (commonArgs
    // rec {
      nativeBuildInputs = leptosNativeBuildInputs;
      cargoBuildCommand = "cargo leptos --log wasm --log server build";
      cargoExtraArgs = "--release";
      installPhaseCommand = ''
        mkdir -p $out/bin;
        mkdir -p $out/usr/share;
        mv ./target/server/release/leptos_portfolio $out/bin/
        mv ./target/site/ $out/usr/share/
      '';
      doCheck = false;
      buildPhaseCargoCommand = "${cargoBuildCommand} ${cargoExtraArgs}";
    }
    // {
      inherit cargoArtifacts;
    });

  wasmArgs =
    commonArgs
    // {
      pname = "leptos_portfolio_csr";
      cargoExtraArgs = "--features csr";
      CARGO_BUILD_TARGET = "wasm32-unknown-unknown";
    };

  cargoArtifactsWasm = crane.buildDepsOnly (wasmArgs
    // {
      doCheck = false;
    });

  leptos_portfolio_csr = crane.buildTrunkPackage (wasmArgs
    // {
      pname = "leptos_portfolio_csr";
      cargoArtifacts = cargoArtifactsWasm;
      trunkIndexPath = "index.html";
    });

  crane = inputs.crane.lib.overrideToolchain cells.repo.rust.toolchain;
in {
  #sane default for a binary package

  default = leptos_portfolio_ssr;
  leptos_portfolio_csr = leptos_portfolio_csr;
}
