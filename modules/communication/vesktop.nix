{ den, ... }:
{
  den.aspects.vesktop.homeManager =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.vesktop = {
        enable = true;
        settings = {
          minimizeToTray = false;
          tray = true;
        };
        vencord = {
          extraQuickCss = /* css */ ''
            /*Highlight text select color */
            [role="textbox"] *::selection {
              background: #7081d0 !important;
            }
          '';
          settings = {
            enabledThemes = [ "stylix.css" ];
            autoUpdate = true;
            autoUpdateNotification = true;
            useQuickCss = true;
            themeLinks = [ ];
            eagerPatches = false;
            enableReactDevtools = false;
            frameless = false;
            transparent = false;
            winCtrlQ = false;
            disableMinSize = false;
            winNativeTitleBar = false;

            plugins = {
              ChatInputButtonAPI.enabled = true;
              CommandsAPI.enabled = true;
              DynamicImageModalAPI.enabled = false;
              MemberListDecoratorsAPI.enabled = false;
              MessageAccessoriesAPI.enabled = true;
              MessageDecorationsAPI.enabled = false;
              MessageEventsAPI.enabled = true;
              MessagePopoverAPI.enabled = false;
              MessageUpdaterAPI.enabled = true;
              ServerListAPI.enabled = false;
              UserSettingsAPI.enabled = true;
              AccountPanelServerProfile.enabled = false;
              AlwaysAnimate.enabled = false;
              AlwaysExpandRoles.enabled = true;
              AlwaysTrust = {
                enabled = true;
                domain = true;
                file = true;
              };
              AnonymiseFileNames = {
                enabled = true;
                anonymiseByDefault = true;
                method = 2;
                randomisedLength = 7;
                consistent = "image";
              };
              AppleMusicRichPresence.enabled = false;
              "WebRichPresence (arRPC)".enabled = false;
              BetterFolders.enabled = false;
              BetterGifAltText.enabled = false;
              BetterGifPicker.enabled = false;
              BetterNotesBox.enabled = false;
              BetterRoleContext.enabled = false;
              BetterRoleDot = {
                enabled = true;
                bothStyles = false;
                copyRoleColorInProfilePopout = false;
              };
              BetterSessions.enabled = false;
              BetterSettings.enabled = false;
              BetterUploadButton.enabled = false;
              BiggerStreamPreview.enabled = false;
              BlurNSFW.enabled = false;
              CallTimer.enabled = false;
              ClearURLs.enabled = true;
              ClientTheme.enabled = false;
              ColorSighted.enabled = false;
              ConsoleJanitor.enabled = false;
              ConsoleShortcuts.enabled = false;
              CopyEmojiMarkdown.enabled = false;
              CopyFileContents.enabled = false;
              CopyStickerLinks.enabled = false;
              CopyUserURLs.enabled = true;
              CrashHandler.enabled = true;
              CtrlEnterSend.enabled = false;
              CustomIdle.enabled = false;
              CustomRPC.enabled = false;
              Dearrow.enabled = false;
              Decor.enabled = false;
              DisableCallIdle.enabled = false;
              DontRoundMyTimestamps.enabled = false;
              Experiments.enabled = false;
              ExpressionCloner.enabled = true;
              F8Break.enabled = false;
              FakeNitro.enabled = false;
              FakeProfileThemes.enabled = false;
              FavoriteEmojiFirst.enabled = true;
              FavoriteGifSearch.enabled = false;
              FixCodeblockGap.enabled = true;
              FixImagesQuality.enabled = false;
              FixSpotifyEmbeds.enabled = false;
              FixYoutubeEmbeds.enabled = true;
              ForceOwnerCrown.enabled = false;
              FriendInvites.enabled = false;
              FriendsSince.enabled = false;
              FullSearchContext.enabled = true;
              FullUserInChatbox.enabled = false;
              GameActivityToggle = {
                enabled = true;
                location = "PANEL";
                oldIcon = false;
              };
              GifPaste.enabled = false;
              GreetStickerPicker.enabled = false;
              HideMedia.enabled = false;
              iLoveSpam.enabled = false;
              IgnoreActivities.enabled = false;
              ImageFilename.enabled = false;
              ImageLink.enabled = true;
              ImageZoom.enabled = false;
              ImplicitRelationships.enabled = false;
              IrcColors.enabled = false;
              KeepCurrentChannel.enabled = true;
              LastFMRichPresence.enabled = false;
              LoadingQuotes.enabled = false;
              MemberCount.enabled = false;
              MentionAvatars.enabled = false;
              MessageClickActions.enabled = false;
              MessageLatency.enabled = false;
              MessageLinkEmbeds.enabled = false;
              MessageLogger = {
                enabled = true;
                collapseDeleted = true;
                deleteStyle = "text";
                ignoreBots = false;
                ignoreSelf = false;
                ignoreUsers = "";
                ignoreChannels = "";
                ignoreGuilds = "";
                logEdits = true;
                logDeletes = true;
                inlineEdits = false;
              };
              MessageTags.enabled = false;
              MoreQuickReactions.enabled = false;
              MutualGroupDMs.enabled = false;
              NewGuildSettings.enabled = false;
              NoBlockedMessages.enabled = false;
              NoDevtoolsWarning.enabled = false;
              NoF1.enabled = false;
              NoMaskedUrlPaste.enabled = false;
              NoMosaic.enabled = false;
              NoOnboardingDelay.enabled = true;
              NoPendingCount.enabled = false;
              NoProfileThemes.enabled = false;
              NoReplyMention.enabled = false;
              NoServerEmojis.enabled = false;
              NoTypingAnimation.enabled = false;
              NoUnblockToJump.enabled = false;
              NormalizeMessageLinks.enabled = false;
              NotificationVolume.enabled = false;
              OnePingPerDM = {
                enabled = false;
                channelToAffect = "both_dms";
                allowMentions = false;
                allowEveryone = false;
              };
              oneko.enabled = false;
              OpenInApp = {
                enabled = true;
                spotify = true;
                steam = true;
                epic = true;
                tidal = true;
                itunes = true;
              };
              OverrideForumDefaults.enabled = false;
              PauseInvitesForever.enabled = false;
              PermissionFreeWill.enabled = false;
              PermissionsViewer.enabled = false;
              petpet.enabled = false;
              PictureInPicture.enabled = false;
              PinDMs.enabled = false;
              PlainFolderIcon.enabled = false;
              PlatformIndicators.enabled = false;
              PreviewMessage.enabled = false;
              QuickMention.enabled = false;
              QuickReply.enabled = false;
              ReactErrorDecoder.enabled = false;
              ReadAllNotificationsButton.enabled = true;
              RelationshipNotifier.enabled = false;
              ReplaceGoogleSearch.enabled = false;
              ReplyTimestamp.enabled = false;
              RevealAllSpoilers.enabled = false;
              ReverseImageSearch.enabled = false;
              ReviewDB.enabled = false;
              RoleColorEverywhere.enabled = false;
              SecretRingToneEnabler.enabled = false;
              Summaries.enabled = false;
              SendTimestamps.enabled = false;
              ServerInfo.enabled = false;
              ServerListIndicators.enabled = false;
              ShikiCodeblocks.enabled = false;
              ShowAllMessageButtons.enabled = false;
              ShowConnections.enabled = false;
              ShowHiddenChannels.enabled = false;
              ShowHiddenThings.enabled = false;
              ShowMeYourName.enabled = false;
              ShowTimeoutDuration.enabled = false;
              SilentMessageToggle.enabled = false;
              SilentTyping = {
                enabled = true;
                isEnabled = true;
                showIcon = false;
                contextMenu = true;
              };
              SortFriendRequests.enabled = false;
              SpotifyControls.enabled = false;
              SpotifyCrack.enabled = false;
              SpotifyShareCommands.enabled = true;
              StartupTimings.enabled = false;
              StickerPaste.enabled = false;
              StreamerModeOnStream.enabled = false;
              SuperReactionTweaks.enabled = false;
              TextReplace.enabled = false;
              ThemeAttributes.enabled = false;
              Translate.enabled = false;
              TypingIndicator = {
                enabled = true;
                includeMutedChannels = false;
                includeCurrentChannel = true;
                includeBlockedUsers = false;
                indicatorMode = 3;
              };
              TypingTweaks.enabled = false;
              Unindent.enabled = false;
              UnlockedAvatarZoom.enabled = false;
              UnsuppressEmbeds.enabled = false;
              UserMessagesPronouns.enabled = false;
              UserVoiceShow.enabled = false;
              USRBG.enabled = false;
              ValidReply.enabled = false;
              ValidUser.enabled = false;
              VoiceChatDoubleClick.enabled = false;
              VcNarrator.enabled = false;
              VencordToolbox.enabled = false;
              ViewIcons.enabled = false;
              ViewRaw.enabled = false;
              VoiceDownload.enabled = false;
              VoiceMessages.enabled = false;
              VolumeBooster.enabled = false;
              WebKeybinds.enabled = true;
              WebScreenShareFixes.enabled = true;
              WhoReacted.enabled = true;
              XSOverlay.enabled = false;
              YoutubeAdblock.enabled = false;
              BadgeAPI.enabled = true;
              NoTrack = {
                enabled = true;
                disableAnalytics = true;
              };
              Settings = {
                enabled = true;
                settingsLocation = "aboveNitro";
              };
              DisableDeepLinks.enabled = true;
              SupportHelper.enabled = true;
              WebContextMenus.enabled = true;
            };

            uiElements = {
              chatBarButtons = { };
              messagePopoverButtons = { };
            };

            notifications = {
              timeout = 5000;
              position = "bottom-right";
              useNative = "not-focused";
              logLimit = 50;
            };
          };
        };
      };

      # Replace HM-managed read-only symlinks with writable copies so vesktop can write settings at runtime
      home.activation.vesktopSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        for f in \
          "$HOME/.config/vesktop/settings.json" \
          "$HOME/.config/vesktop/settings/settings.json"; do
          if [ -L "$f" ]; then
            target=$(readlink "$f")
            rm "$f"
            cp "$target" "$f"
            chmod 644 "$f"
          fi
        done
      '';

      # Create systemd service for vesktop with proper ordering
      systemd.user.services.vesktop = {
        Unit = {
          Description = "Vesktop Discord Client";
          After = lib.mkIf config.programs.noctalia.enable [
            "graphical-session.target"
            "noctalia.service"
          ];
          Wants = lib.mkIf config.programs.noctalia.enable [ "noctalia.service" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${config.programs.vesktop.package}/bin/vesktop";
          Restart = "on-failure";
          RestartSec = 3;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
