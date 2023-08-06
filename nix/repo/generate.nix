# https://github.com/divnix/std/tree/main/src/lib/ops
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;

  l = nixpkgs.lib // builtins;

  #sedReplacement = schema : args : ''OUT=$(sed -e "s/PAGENAME/%PAGENAME/g" ${schema})'';
  #sedReplacement = schema : args : ''OUT=$(sed ${l.concatMapStringsSep " " (x: "-e \"s/${args}/\$${x.arg}/g\"") (args)} ${schema})'';
  sedReplacement = schema: args: ''OUT=$(sed ${l.concatMapStringsSep " " (x: "-e \"s/${x}/\$${l.toString (l.getAttr x args)}/g\"") (l.attrNames args)} ${schema})'';

  templates = {
    page = rec {
      usage = "page <name>";
      description = "generates a leptos page template in the pages directory";
      template-name = "page";

      args = {
        PAGENAME = 1;
      };

      schema = l.toFile template-name ''
        use leptos::*;
        use leptos_meta::*;


        #[component]
        fn PAGENAME(cx: Scope) -> impl IntoView {
        	// Creates a reactive value to update the button
        	let (count, set_count) = create_signal(cx, 1f64);
        	let on_click = move |_| set_count.update(|count| *count += *count - 2.);

        	view! { cx,
        		<h1>"PAGENAME"</h1>
        	}
        }
      '';

      generate = sedReplacement schema args;

      postGenerate = ''
        mkdir src/pages/
        echo "$OUT" > src/pages/"$1"
      '';
    };
  };
in {
  generate =
    std.lib.ops.writeScript {
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
            ${x.generate}
            ${x.postGenerate}
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
