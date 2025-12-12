{ ... }: {
  programs.nixvim = {
    plugins.persistence = {
      enable = true;
      settings = {
        need = 1;
        branch = true;
      };
    };
  };
}
