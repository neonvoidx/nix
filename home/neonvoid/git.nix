{ ... }:
{
  programs.git = {
    settings = {
      credential = {
        "https://github.com" = {
          helper = "!/usr/bin/gh auth git-credential";
        };
      };
      user = {
        name = "neonvoidx";
        email = "me@neonvoid.dev";
      };
    };
  };
}
