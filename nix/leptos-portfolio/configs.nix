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
  inherit (inputs) nixpkgs presets;
  inherit (inputs.std) std lib;
  
  l = nixpkgs.lib // builtins;
in
  # The structure is an attribute set where the value is an attribute set that
  # is ultimately passed to the `make`[1] function from Nixago. The available
  # arguments for the `make` function can be seen here[2].
  #
  # `std` allows us to pass additional pass-through arguments that can influence
  # the behavior of our development shells. This is primarily used so we can
  # include the necessary packages for the tools we want to configure into the
  # development environment.
  #
  # Additionally, `std` automatically includes any shell hooks generated by Nixago
  # into the appropriate `devshell` option. This is ultimately what allows Nixago
  # to generate the configurations when we enter the development shell.
  #
  # [1]: https://github.com/nix-community/nixago/blob/master/lib/make.nix
  # [2]: https://github.com/nix-community/nixago/blob/master/modules/request.nix
  {
    # The `std` framework ships with some "pre-configured" services that we can
    # import and use here. For a list of all of them, see here[1]. These are setup
    # such that we can use a functor to dynamically extend them with additional
    # attributes or overrides. This is why they appear to look like functions.
    #
    # In most cases, when using these pre-configured services, we only need to be
    # concerned with setting the `configData` attribute. This is what ultimately
    # ends up in the generated configuration file and is dependent on what tool
    # is being configured.
    #
    # Conform[2] is a tool that allows us to enforce policies on our commit
    # messages. We configure it here to only allow commits that follow the
    # Conventional Commits specification[3].
    #
    # [1]: https://github.com/divnix/std/tree/main/cells/std/nixago
    # [2]: https://github.com/siderolabs/conform
    # [3]: https://www.conventionalcommits.org/en/v1.0.0/
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
   # treefmt = presets.nixago.treefmt {
      #configData = {
        #formatter = {
          #nix = {
            #command = "alejandra";
            #includes = ["*.nix"];
          #};
          #prettier = {
            #command = "prettier";
            #options = ["--write"];
            #includes = ["*.md"];
          #};
          #rustfmt = {
            #command = "rustfmt";
            #options = ["--edition" "2021"];
            #includes = ["*.rs"];
          #};
        #};
      #};
      ## This is the pass-through feature where we can pass attributes to devshell.
      ## In this case, we're asking devshell to include the `nixpkgs-fmt` and
      ## `prettier` packages in the development environment. The `rustfmt` package
      ## is already included within the Rust toolchain (see toolchain.nix).
      #packages = [
        #nixpkgs.alejandra
        #nixpkgs.nodePackages.prettier
      #];
    #};
  }
