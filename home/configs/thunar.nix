{ pkgs, ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = "nvim.desktop";
      "text/x-shellscript" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "text/x-python" = "nvim.desktop";
      "text/x-csrc" = "nvim.desktop";
      "text/x-c++src" = "nvim.desktop";
      "text/x-java" = "nvim.desktop";
      "text/javascript" = "nvim.desktop";
      "application/javascript" = "nvim.desktop";
      "text/html" = "nvim.desktop";
      "text/css" = "nvim.desktop";
      "application/json" = "nvim.desktop";
      "application/xml" = "nvim.desktop";
      "text/xml" = "nvim.desktop";
      "text/x-yaml" = "nvim.desktop";
      "application/x-yaml" = "nvim.desktop";
      "text/x-rust" = "nvim.desktop";
      "text/x-go" = "nvim.desktop";
      "application/x-shellscript" = "nvim.desktop";
      "text/x-lua" = "nvim.desktop";
      "text/x-makefile" = "nvim.desktop";
      "text/x-log" = "nvim.desktop";
      "application/toml" = "nvim.desktop";
      "text/x-nix" = "nvim.desktop";
    };
  };

  dconf.settings = {
    "org/gtk/settings/file-chooser" = {
      show-hidden = true;
    };
  };

  xfconf.settings = {
    xfce4-terminal = {
      "terminal/emulator" = "kitty";
    };
  };

  xdg.configFile."Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
      <action>
        <icon>utilities-terminal</icon>
        <name>Open Terminal Here</name>
        <command>kitty --working-directory %f</command>
        <description>Open kitty terminal in the current directory</description>
        <patterns>*</patterns>
        <startup-notify/>
        <directories/>
      </action>
    </actions>
  '';

  home.packages = with pkgs; [
    xfce4-exo
  ];

  xdg.configFile."xfce4/helpers.rc".text = ''
    TerminalEmulator=kitty
  '';

  xdg.dataFile."applications/nvim.desktop".text = ''
    [Desktop Entry]
    Name=Neovim
    Exec=kitty -e nvim %F
    Terminal=false
    Type=Application
    Keywords=Text;editor;
    Icon=nvim
    Categories=Utility;TextEditor;
    StartupNotify=false
  '';
}
