{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;
  l = nixpkgs.lib // builtins;

  name = "leptos_portfolio";
  operable = cell.operables.leptos_porfolio;
in {
  leptos_porfolio = std.lib.ops.mkStandardOCI {
    inherit name operable;
  };
  leptos_porfolio-debug = std.lib.ops.mkStandardOCI {
    inherit name operable;
    debug = true;
  };
}
