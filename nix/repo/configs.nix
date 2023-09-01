# This cell block holds our Nixago expressions for generating configuration
# files for the various tools we want to configure in our repository. We title
# it `configs.nix` because Nixago is less well-known and this name points to the
# purpose of the cell block.
#
# For an introduction to Nixago, see here:
# https://nix-community.github.io/nixago/
{
  inputs,
  cell,
}: let
  inherit (inputs.std) lib;
in {
  editorconfig =
    lib.dev.mkNixago lib.cfg.editorconfig
    {
      data = {
        root = true;
        "*" = {
          end_of_line = "lf";
          insert_final_newline = true;
          trim_trailing_whitespace = true;
          charset = "utf-8";
          indent_style = "space";
          indent_size = 2;
        };

        "*.{diff,patch}" = {
          end_of_line = "unset";
          insert_final_newline = "unset";
          trim_trailing_whitespace = "unset";
          indent_size = "unset";
        };

        "*.md" = {
          max_line_length = "off";
          trim_trailing_whitespace = false;
        };

        "{LICENSES/**,LICENSE}" = {
          end_of_line = "unset";
          insert_final_newline = "unset";
          trim_trailing_whitespace = "unset";
          charset = "unset";
          indent_style = "unset";
          indent_size = "unset";
        };
      };
    };

  treefmt = (
    lib.dev.mkNixago lib.cfg.treefmt
    {
      packages = [
        inputs.nixpkgs.alejandra
        inputs.nixpkgs.nodePackages.prettier
        #inputs.nixpkgs.nodePackages.prettier-plugin-toml
        inputs.nixpkgs.shfmt
      ];
      # devshell.startup.prettier-plugin-toml =
      #   inputs.nixpkgs.lib.stringsWithDeps.noDepEntry
      #   ''
      #     export NODE_PATH=${inputs.nixpkgs.nodePackages.prettier-plugin-toml}/lib/node_modules:''${NODE_PATH-}
      #   '';
      data = {
        formatter = {
          nix = {
            command = "alejandra";
            includes = ["*.nix"];
          };
          prettier = {
            command = "prettier";
            options = [
              "--write"
            ];
            includes = [
              "*.css"
              "*.html"
              "*.js"
              "*.json"
              "*.jsx"
              "*.md"
              "*.mdx"
              "*.scss"
              "*.ts"
              "*.yaml"
            ];
          };
          shell = {
            command = "shfmt";
            options = [
              "-i"
              "2"
              "-s"
              "-w"
            ];
            includes = ["*.sh"];
          };
          #  rustfmt = {
          #    command = "rustfmt";
          #    includes = ["*.rs"];
          #    options = [
          #      "--edition"
          #      "2021"
          #    ];
          #};
        };
      };
    }
  );
  # Tool Homepage: https://github.com/evilmartians/lefthook

  lefthook = (
    lib.dev.mkNixago lib.cfg.lefthook
    {
      data = {
        commit-msg = {
          commands = {
            conform = {
              # allow WIP, fixup!/squash! commits locally
              run = ''
                [[ "$(head -n 1 {1})" =~ ^WIP(:.*)?$|^wip(:.*)?$|fixup\!.*|squash\!.* ]] ||
                conform enforce --commit-msg-file {1}'';
              skip = [
                "merge"
                "rebase"
              ];
            };
          };
        };
        pre-commit = {
          commands = {
            treefmt = {
              run = "treefmt {staged_files}";
              skip = [
                "merge"
                "rebase"
              ];
            };
          };
        };
      };
    }
  );

  # Prettier is a multi-language code formatter.
  prettier = lib.dev.mkNixago {
    # We mainly use it here to format the Markdown in our README.
    data = {
      printWidth = 80;
      proseWrap = "always";
    };
    output = ".prettierrc";
    format = "json";
  };
  # Treefmt is an aggregator for source code formatters. Our codebase has
  # markdown, Nix, and Rust, so we configure a formatter for each.
}
