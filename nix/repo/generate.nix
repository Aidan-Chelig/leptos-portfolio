# https://github.com/divnix/std/tree/main/src/lib/ops
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;

  l = nixpkgs.lib // builtins;

  templates = {
    thing = {
      usage = "thing <name>";
      description = "just a test";

      derivation =
        std.lib.ops.writeScript
        {
          name = "thing";
          text = ''
            echo "generateingpage"
          '';
        };
    };

    Page = {
      usage = "page <name>";
      description = "generates a leptos page template in the pages directory";

      derivation =
        std.lib.ops.writeScript
        {
          name = "page";
          text = ''
            echo "generateingpage"
          '';
        };
    };
  };
in {
  generate = std.lib.ops.writeScript {
    runtimeInputs = l.map (x: x.derivation) (l.attrValues templates);
    name = "generate";
    text = ''
      if GPATH=$(git rev-parse --show-toplevel --quiet 2>/dev/null); then
        cd "$GPATH";
      else
        echo "Not a valid Git repository, exiting"
        exit
      fi

      if [ $# -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]
      then
        echo "usage: generate <template-name> <template-args>";
        printf "available templates:\n\n"
        echo "${l.concatMapStringsSep "\n" (x: "${x.usage}\n${x.description}\n") (l.attrValues templates)}"
      fi

      if [ $# -gt 0 ]
      then
        shift;
        echo "$@";
      fi



    '';
  };
  # ${l.concatStringsSep "\n" (l.map (x: "${x}/bin/${x.name}") (l.attrValues templates))}
}
