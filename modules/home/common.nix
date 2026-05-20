{ den, ... }:
{
  den.aspects.common.homeManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      home.activation.cleanupLegacyKvantumBase16 = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
        target="$HOME/.config/Kvantum/Base16Kvantum"
        if [ -L "$target" ] && [ ! -d "$target" ]; then
          rm -f "$target"
        fi
      '';

      home = {
        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
          BROWSER = "firefox";
          TERMINAL = "kitty";
          SSH_ASKPASS_REQUIRE = "never";
        };
      };

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
          "*" = {
            AddKeysToAgent = "yes";
          };
        };
      };

      services = {
        ssh-agent.enable = true;
        playerctld.enable = true;
        # For tray icons that don't behave properly, like bnet with xwayland/proton
        xembed-sni-proxy.enable = true;
      };

      # Enable bash just for shell scripts and stuff, even though we use ZSH
      programs.bash.enable = true;
      programs.home-manager.enable = true;
    };
}
