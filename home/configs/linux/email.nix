{ username, ... }:
{
  services.protonmail-bridge = {
    enable = true;
  };
  accounts.email.accounts.${username}.thunderbird = {
    enable = true;
  };
}
