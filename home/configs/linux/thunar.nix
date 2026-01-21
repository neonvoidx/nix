{ pkgs, ... }:
{
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
    xfce.exo
  ];

  xdg.configFile."xfce4/helpers.rc".text = ''
    TerminalEmulator=kitty
  '';
}
