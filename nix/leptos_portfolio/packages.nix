{
  inputs,
  cell,
}: let
  inherit (inputs) std self cells nixpkgs;

  leptosNativeBuildInputs = with nixpkgs; [
    cargo-leptos
    binaryen
    #dart-sass
    openssl
    pkg-config
  ];

  commonArgs = {
    src = std.incl self [
      "${self}/Cargo.lock"
      "${self}/Cargo.toml"
      "${self}/src"
      "${self}/assets"
      "${self}/style"
      "${self}/index.html"
    ];
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
      trunkExtraBuildArgs = "--features csr";
    });

  crane = inputs.crane.lib.overrideToolchain cells.repo.rust.toolchain;
in {
  #sane default for a binary package

  default = leptos_portfolio_ssr;
  leptos_portfolio_ssr = leptos_portfolio_ssr;
  leptos_portfolio_csr = leptos_portfolio_csr;
}
