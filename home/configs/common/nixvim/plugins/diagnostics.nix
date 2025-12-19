{ ... }:
{
  plugins = {
    trouble = {
      enable = true;
      autoLoad = true;
    };
    lint = {
      enable = true;
      lintersByFt = {
        typescript = [ "eslint_d" ];
      };
    };
  };
}
