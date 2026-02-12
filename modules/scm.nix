{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.git = {
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

      programs.mercurial = {
        enable = true;
        userName = "Invra";
        userEmail = "identificationsucks@gmail.com";
      };

      home.packages = with pkgs; [
        darcs
        glab
        gh
      ];
    };
}
