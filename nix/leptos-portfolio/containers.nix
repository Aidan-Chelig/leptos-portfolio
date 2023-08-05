{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;
  l = nixpkgs.lib // builtins;

  name = "leptos-portfolio";
  operable = cell.operables.leptos-porfolio;
in {
  leptos-porfolio = std.lib.ops.mkStandardOCI {
    inherit name operable;
  };
}
