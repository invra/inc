{
  flake.modules.homeManager.base = let
    rosepine-gtk = fetchGit {
      url = "https://github.com/rose-pine/gtk";
      rev = "3a11f84e11685aacaa749deea1e9f02872b99fdf";
      shallow = true;
    };
  in {
    xdg.configFile."gtk-4.0/gtk.css".source = "${rosepine-gtk}/gtk4/rose-pine.css"; 
  };
}