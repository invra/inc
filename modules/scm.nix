let
  polyModule =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
      ];
    };
in
{
  flake.modules = {
    darwin.base = polyModule;
    nixos.base = polyModule;
    homeManager.base =
      { pkgs, ... }:
      {
        programs = {
          jujutsu = {
            enable = true;
            settings = {
              user = {
                name = "Invra";
                email = "identificationsucks@gmail.com";
              };
              alias = {
                a = "add";
                p = "push -v";
                s = "status -s";
                c = "commit -m";
                b = "branch --all";
                co = "checkout -b";
                m = "commit --amend";
              };
              init.defaultBranch = "main";
              core.quotepath = "off";
            };
          };

          git = {
            enable = true;
            settings = {
              user = {
                name = "Invra";
                email = "identificationsucks@gmail.com";
              };
              alias = {
                a = "add";
                p = "push -v";
                s = "status -s";
                c = "commit -m";
                b = "branch --all";
                co = "checkout -b";
                m = "commit --amend";
              };
              init.defaultBranch = "main";
              core.quotepath = "off";
            };
          };

          difftastic = {
            enable = true;

            jujutsu.enable = true;
            git.enable = true;
          };
        };

        home.packages = with pkgs; [
          onefetch
          tokei
          darcs
          glab
          gh
        ];
      };
  };
}
