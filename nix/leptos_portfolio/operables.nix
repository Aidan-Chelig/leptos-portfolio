{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;

  l = nixpkgs.lib // builtins;

  package = cell.packages.default;
in {
  leptos-porfolio = std.lib.ops.mkOperable {
    inherit package;

    meta.mainProgram = package;

    runtimeEnv = {
      LEPTOS_OUTPUT_NAME = "leptos_portfolio";
      LEPTOS_SITE_ROOT = "${package}/usr/share/site";
      LEPTOS_SITE_PKG_DIR = "pkg";
      LEPTOS_SITE_ADDR = "127.0.0.1:3000";
      LEPTOS_RELOAD_PORT = "3001";
    };

    debugInputs = with nixpkgs; [
      nettools
    ];

    runtimeScript = ''
      ${package}/bin/leptos_portfolio
    '';
  };
}
