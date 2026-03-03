{ den, ... }:
{
  den.aspects.lsd.homeManager =
    { config, ... }:
    let
      c = config.lib.stylix.colors;
    in
    {
      programs.lsd = {
        enable = true;
        enableZshIntegration = false;
        settings = {
          color = {
            when = "auto";
            theme = "custom";
          };
        };
      };

      programs.zsh.shellAliases = {
        ls = "lsd";
        l = "ls -Al";
        lt = "ls --tree --ignore-glob=node_modules";
      };

      xdg.configFile."lsd/themes/custom.yaml".text = ''
        user: "#${c.base0C}"
        group: "#${c.base0E}"
        permission:
          read: "#${c.base0B}"
          write: "#${c.base0A}"
          exec: "#${c.base08}"
          exec-sticky: "#${c.base0F}"
          no-access: "#${c.base03}"
          octal: "#${c.base0C}"
          acl: "#${c.base0C}"
          context: "#${c.base0C}"
        date:
          hour-old: "#${c.base0C}"
          day-old: "#${c.base0D}"
          older: "#${c.base0E}"
        size:
          none: "#${c.base03}"
          small: "#${c.base0A}"
          medium: "#${c.base09}"
          large: "#${c.base08}"
        inode:
          valid: "#${c.base03}"
          invalid: "#${c.base08}"
        links:
          valid: "#${c.base0C}"
          invalid: "#${c.base08}"
        tree-edge: "#${c.base0E}"
        git-status:
          default: "#${c.base03}"
          unmodified: "#${c.base02}"
          ignored: "#${c.base03}"
          new-in-index: "#${c.base0B}"
          new-in-workdir: "#${c.base0B}"
          typechange: "#${c.base09}"
          deleted: "#${c.base08}"
          renamed: "#${c.base09}"
          modified: "#${c.base0A}"
          conflicted: "#${c.base08}"
      '';
    };
}
