{
  programs.nixvim = {
    plugins.copilot-lua.enable = true;
    plugins.sidekick = {
      enable = true;
      settings = {
        nes = { enabled = false; };
        cli = {
          mux = { enabled = false; };
          tools = {
            aider = { cmd = [ "ocaider" "--watch-files" "--model oca/gpt5" ]; };
          };
        };
      };
    };
  };
}
