# https://github.com/divnix/std/tree/main/src/lib/ops
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;

  l = nixpkgs.lib // builtins;

  # Creates a sed command to replace all instances of your args name with the corrisponding bash argument number eg s/PAGENAME/$1/g
  #sedReplacement = schema: args: ''OUT=$(sed ${l.concatMapStringsSep " " (x: "-e \"s/${x}/\$${l.toString (l.getAttr x args)}/g\"") (l.attrNames args)} ${schema})'';
  phpReplacement = schema: ''OUT=$(php ${schema} "$@")'';

  templates = {
    page = rec {
      usage = "page <name>";
      description = "generates a leptos page template in the pages directory";
      template-name = "page";

      args = {
        PAGENAME = 1;
      };

      schema = l.toFile "${template-name}-schema" (l.readFile ./templates/page.php);

      preGenerate = ''
        # Uppercase the first letter of the page name to fit leptos naming convention.
          set -- "''${1^}"
      '';

      generate = phpReplacement schema;

      postGenerate = ''
        LC=$(echo "$1" | tr '[:upper:]' '[:lower:]')
        if [ -e src/app/pages/"$LC".rs ]
        then
          echo "The page $1 already exists, remove it or try a different name."
          exit
        fi
        mkdir -p src/app/pages/
        echo "$OUT" > src/app/pages/"$LC".rs
        echo "
        mod $LC;
        pub use $LC::$1;" >> src/app/pages/mod.rs
      '';
    };
  };
in {
  generate =
    std.lib.ops.writeScript {
      runtimeInputs = [nixpkgs.php];
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

        ${l.concatMapStringsSep "\n" (x: ''
          if [ "$1" = "${x.template-name}" ]
          then
            shift;
            ${x.preGenerate}
            ${x.generate}
            ${x.postGenerate}
            exit
          fi
        '') (l.attrValues templates)}

          shift;
          echo "$@";
        fi
      '';
    }
    // {
      meta.description = "A quick templating solution using nix and sed";
    };
  # ${l.concatStringsSep "\n" (l.map (x: "${x}/bin/${x.name}") (l.attrValues templates))}
}
