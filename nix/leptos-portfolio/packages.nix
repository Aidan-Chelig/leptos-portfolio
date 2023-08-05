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

  # i cant build the dependencies because of how leptos is setup. i'll have to think of a solution.
  # maybe 2 derivations one for front and one for server then merge them?
  # cargoArtifacts = crane.buildDepsOnly (commonArgs
  # // {
  # cargoExtraArgs = "--all-features --profile release --features=ssr";
  # });

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
      inherit cargoArtifacts;
    });

  crane = inputs.crane.lib.overrideToolchain cells.repo.rust.toolchain;
in {
  #sane default for a binary package

  default = leptos-portfolio;
}
