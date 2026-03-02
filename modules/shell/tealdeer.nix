{ den, ... }:
{
  den.aspects.tealdeer.homeManager =
    { ... }:
    {
      programs.tealdeer = {
        enable = true;
        enableAutoUpdates = true;
        settings = {
          style = {
            description = {
              underline = false;
              bold = false;
              italic = false;
            };
            command_name = {
              foreground = "cyan";
              underline = false;
              bold = false;
              italic = false;
            };
            example_text = {
              foreground = "green";
              underline = false;
              bold = false;
              italic = false;
            };
            example_code = {
              foreground = "cyan";
              underline = false;
              bold = false;
              italic = false;
            };
            example_variable = {
              foreground = "cyan";
              underline = true;
              bold = false;
              italic = false;
            };
          };
          display = {
            compact = false;
            use_pager = false;
            show_title = false;
          };
          updates = {
            auto_update = true;
            auto_update_interval_hours = 720;
          };
        };
      };
    };
}
