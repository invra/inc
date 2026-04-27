{
  inputs,
  ...
}:
let
  inherit (inputs) flake-parts import-tree;
in
flake-parts.lib.mkFlake { inherit inputs; } {
  imports = [
    (import-tree ./hosts)
    (import-tree ./custom)
    (import-tree ./modules)
  ];
  _module.args.rootPath = ./.;
}
