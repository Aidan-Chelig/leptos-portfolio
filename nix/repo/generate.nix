# https://github.com/divnix/std/tree/main/src/lib/ops
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;

  l = nixpkgs.lib // builtins;
in {
  generate = std.lib.ops.writeScript {
    runtimeInputs = [];
    name = "generate";
    text = ''
      echo "INITsss"
    '';
  };
}
