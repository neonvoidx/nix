{...}: {
  plugins.conform-nvim = {
    enable=true;
    autoInstall.enable=true;
    settings ={
     formatters_by_ft = {
       nix = ["nil"]
     };
    };
  };
}
