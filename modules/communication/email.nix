{ den, lib, ... }:
{
  den.aspects.email =
    { user, ... }:
    let
      accounts = user.emailAccounts or { };
      names = builtins.attrNames accounts;
      accountOrder =
        lib.filter (name: accounts.${name}.primary or false) names
        ++ lib.filter (name: !(accounts.${name}.primary or false)) names;
      secretFields = lib.concatMap (
        name:
        lib.concatMap
          (
            field:
            lib.optional (accounts.${name} ? ${field + "Secret"}) (
              let
                secret = accounts.${name}.${field + "Secret"};
                placeholder = "<SOPS:${builtins.hashString "sha256" secret}:PLACEHOLDER>";
              in
              {
                inherit
                  name
                  field
                  secret
                  placeholder
                  ;
                # Home Manager requires addresses to contain @ even before rendering.
                marker = placeholder + lib.optionalString (field == "address") "@sops.invalid";
              }
            )
          )
          [
            "address"
            "userName"
          ]
      ) names;
      secretNames = lib.unique (map (entry: entry.secret) secretFields);
      hasSecrets = secretNames != [ ];
      templateName = "thunderbird-${user.userName}-user.js";
      userJs = ".thunderbird/default/user.js";
    in
    {
      nixos =
        { config, ... }:
        lib.optionalAttrs hasSecrets {
          sops.secrets = lib.genAttrs secretNames (_: {
            owner = user.userName;
            mode = "0400";
          });
          sops.templates.${templateName} = {
            owner = user.userName;
            mode = "0400";
            # Secrets contain JSON string literals, including quotes. Replace the
            # entire quoted marker so special characters remain valid JavaScript.
            content = builtins.replaceStrings (map (entry: builtins.toJSON entry.marker) secretFields) (map (
              entry: config.sops.placeholder.${entry.secret}
            ) secretFields) config.home-manager.users.${user.userName}.home.file.${userJs}.text;
          };
          systemd.services."home-manager-${user.userName}" = {
            after = [ "sops-install-secrets.service" ];
            requires = [ "sops-install-secrets.service" ];
          };
        };

      homeManager = { config, osConfig, ... }: {
        programs.thunderbird = {
          enable = true;
          settings."privacy.donottrackheader.enabled" = true;
          profiles.default = {
            isDefault = true;
            accountsOrder = accountOrder;
            extensions = [ ];
            settings.extensions.autoDisableScopes = 0;
          };
        };
        accounts.email.accounts = lib.mapAttrs (
          name: account:
          builtins.removeAttrs account [
            "addressSecret"
            "userNameSecret"
          ]
          // builtins.listToAttrs (
            map (entry: {
              name = entry.field;
              value = entry.marker;
            }) (lib.filter (entry: entry.name == name) secretFields)
          )
          // {
            thunderbird = {
              enable = true;
              profiles = [ "default" ];
            };
          }
        ) accounts;

        # Keep HM's generated text as the template, but link the rendered file.
        home.file.${userJs}.source = lib.mkIf hasSecrets (
          lib.mkForce (config.lib.file.mkOutOfStoreSymlink osConfig.sops.templates.${templateName}.path)
        );
      };
    };
}
