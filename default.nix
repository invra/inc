{
  flake-parts,
  ...
}@inputs:
let
  import-tree = import ./lib/import-tree.nix;
in
flake-parts.lib.mkFlake { inherit inputs; } {
  imports = [
    (import-tree ./auto)
    (import-tree ./hosts)
    (import-tree ./custom)
    (import-tree ./modules)
  ];
}
