{
  flake.modules.homeManager.base =
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

        mercurial = {
          enable = true;
          package = pkgs.mercurial.override { rustSupport = true; };
          userName = "Invra";
          userEmail = "identificationsucks@gmail.com";
          aliases = {
            a = "add";
            p = "push -v";
            s = "status";
            c = "commit -m";
            b = "branch";
            m = "commit --amend";
          };
        };

        difftastic = {
          enable = true;

          jujutsu.enable = true;
          git.enable = true;
        };
      };

      home.packages = with pkgs; [
        darcs
        glab
        gh
      ];
    };
}
