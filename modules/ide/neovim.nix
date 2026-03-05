{ den, inputs, ... }:
{
  den.aspects.neovim.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ (inputs.nvim-config.wrappers.neovim.wrap { inherit pkgs; }) ];
    };
}
