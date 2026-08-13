{ den, ... }:
{
  den.aspects.discord.homeManager =
    { config, lib, ... }:
    {
      programs.nixcord = {
        enable = true;

        discord = {
          equicord.enable = true;
          openASAR.enable = true;
        };

        config = {
          plugins = {
            alwaysExpandRoles.enable = true;
            alwaysTrust.enable = true;
            # autoJumpToMessage.enable = true;
            anonymiseFileNames = {
              enable = true;
              method = 2;
            };
            betterRoleDot.enable = true;
            blockKrisp.enable = true;
            bypassPinPrompt.enable = true;
            clearUrls.enable = true;
            copyUserUrls.enable = true;
            crashHandler.enable = true;
            decodeBase64.enable = true;
            disableDeepLinks.enable = true;
            expressionCloner.enable = true;
            favoriteEmojiFirst.enable = true;
            fixCodeblockGap.enable = true;
            fixYoutubeEmbeds.enable = true;
            fullSearchContext.enable = true;
            gameActivityToggle.enable = true;
            gifPaste.enable = true;
            homeTyping.enable = true;
            imageLink.enable = true;
            keepCurrentChannel.enable = true;
            markdownTables.enable = true;
            messageLogger = {
              enable = true;
              collapseDeleted = true;
              inlineEdits = false;
            };
            noOnboardingDelay.enable = true;
            noTrack.enable = true;
            openInApp.enable = true;
            questify = {
              enable = true;
              disableAccountPanelPromo = true;
              disableFriendsListPromo = true;
              disableMembersListPromo = true;
              disableQuestsEverything = true;
              disableRelocationNotices = true;
            };
            readAllNotificationsButton.enable = true;
            settings.enable = true;
            silentTyping.enable = true;
            spotifyShareCommands.enable = true;
            supportHelper.enable = true;
            tenorGifSearch.enable = true;
            typingIndicator.enable = true;
            webContextMenus.enable = true;
            webKeybinds.enable = true;
            webScreenShareFixes.enable = true;
            whoReacted.enable = true;
          };
        };
      };

      # Create systemd service for discord with proper ordering
      systemd.user.services.discord = {
        Unit = {
          Description = "Discord Client";
          After = lib.mkIf config.programs.noctalia.enable [
            "graphical-session.target"
            "noctalia.service"
          ];
          Wants = lib.mkIf config.programs.noctalia.enable [ "noctalia.service" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${config.programs.nixcord.finalPackage.discord}/bin/discord";
          Restart = "on-failure";
          RestartSec = 3;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
