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
in
  {
      treefmt = {
    packages = [
      inputs.nixfmt.packages.nixfmt
      inputs.nixpkgs.nodePackages.prettier
      inputs.nixpkgs.nodePackages.prettier-plugin-toml
      inputs.nixpkgs.shfmt
    ];
    devshell.startup.prettier-plugin-toml =
      inputs.nixpkgs.lib.stringsWithDeps.noDepEntry
        ''
          export NODE_PATH=${inputs.nixpkgs.nodePackages.prettier-plugin-toml}/lib/node_modules:''${NODE_PATH-}
        ''
    ;
    data = {
      formatter = {
        nix = {
          command = "nixfmt";
          includes = [ "*.nix" ];
          excludes = [ "courses/*" ];
        };
        prettier = {
          command = "prettier";
          options = [
            "--plugin"
            "prettier-plugin-toml"
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
            "*.toml"
          ];
          excludes = [ "courses/*" ];
        };
        shell = {
          command = "shfmt";
          options = [
            "-i"
            "2"
            "-s"
            "-w"
          ];
          excludes = [ "courses/*" ];
          includes = [ "*.sh" ];
        };
        rustfmt = {
          command = "rustfmt";
          includes = [ "*.rs" ];
          options = [
            "--edition"
            "2021"
          ];
          excludes = [ "courses/*" ];
        };
      };
    };
  };
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
