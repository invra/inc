{
  nixConfig = {
    abort-on-warn = false;
    extra-experimental-features = [ "pipe-operators" ];
  };

  inputs = {
    dev-nix.url = "gitlab:invra/nix-dev";
    discord-rpc-lsp.url = "gitlab:invra/discord-rpc-lsp";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    helium.url = "github:vikingnope/helium-browser-nix-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (inputs.import-tree ./hosts)
        (inputs.import-tree ./modules)
      ];

      _module.args.rootPath = ./.;
    };
}
