# Top-level metadata and configuration options
{ lib, ... }:
{
  options = {
    # Default Linux username
    username = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "neonvoid";
      description = "Primary Linux username";
    };
    
    # macOS username
    macUsername = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "jrreed";
      description = "macOS username";
    };
  };
}
