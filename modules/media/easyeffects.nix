{ den, ... }:
{
  den.aspects.easyeffects.homeManager =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      xdg.configFile = {
        "easyeffects/autoload/easyeffectsrc".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/easyeffects/autoload/easyeffectsrc";
        "easyeffects/autoload/microphone.json".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/easyeffects/autoload/microphone.json";
        "easyeffects/autoload/speexrc".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/easyeffects/autoload/speexrc";
        "easyeffects/autoload/equalizerrc".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/easyeffects/autoload/equalizerrc";
      };

      # EasyEffects 8.x uses Qt/KDE config instead of dconf
      # Note: Qt version doesn't have system tray support - feature was removed in Qt port
      # Settings are managed via ~/.config/easyeffects/autoload/easyeffectsrc and db/easyeffectsrc
      services.easyeffects = {
        enable = true;
        # TODO doesn't seem to autoload
        # preset = "headphones";
        extraPresets = {
          # NOTE: Mic preset, commented out for now, i've had better luck with RNNoise
          # microphone = {
          #   input = {
          #     blocklist = [ ];
          #     "compressor#0" = {
          #   attack = 15.0;
          #   boost-amount = 0.0;
          #   boost-threshold = -72.0;
          #   bypass = false;
          #   dry = -80.01;
          #   hpf-frequency = 10.0;
          #   hpf-mode = "Off";
          #   input-gain = 0.0;
          #   input-to-link = 0.0;
          #   input-to-sidechain = 0.0;
          #   knee = -6.0;
          #   link-to-input = 0.0;
          #   link-to-sidechain = 0.0;
          #   lpf-frequency = 20000.0;
          #   lpf-mode = "Off";
          #   makeup = 3.0;
          #   mode = "Downward";
          #   output-gain = 0.0;
          #   ratio = 3.0;
          #   release = 200.0;
          #   release-threshold = -40.0;
          #   sidechain = {
          #     lookahead = 0.0;
          #     mode = "RMS";
          #     preamp = 0.0;
          #     reactivity = 10.0;
          #     source = "Middle";
          #     stereo-split-source = "Left/Right";
          #     type = "Feed-forward";
          #   };
          #   sidechain-to-input = 0.0;
          #   sidechain-to-link = 0.0;
          #   stereo-split = false;
          #   threshold = -18.0;
          #   wet = 0.0;
          # };
          # "deepfilternet#0" = {
          #   attenuation-limit = 100.0;
          #   bypass = false;
          #   input-gain = 0.0;
          #   max-df-processing-threshold = 20.0;
          #   max-erb-processing-threshold = 30.0;
          #   min-processing-buffer = 0;
          #   min-processing-threshold = 5.0;
          #   output-gain = 0.0;
          #   post-filter-beta = 1.9999999552965164e-2;
          # };
          # "deesser#0" = {
          #   bypass = false;
          #   detection = "RMS";
          #   f1-freq = 4000.0;
          #   f1-level = -6.0;
          #   f2-freq = 8000.0;
          #   f2-level = -6.0;
          #   f2-q = 1.5;
          #   input-gain = 0.0;
          #   laxity = 15;
          #   makeup = 0.0;
          #   mode = "Split";
          #   output-gain = 0.0;
          #   ratio = 3.0;
          #   sc-listen = false;
          #   threshold = -22.0;
          # };
          # "equalizer#0" = {
          #   balance = 0.1;
          #   bypass = false;
          #   input-gain = 0.0;
          #   left = {
          #     band0 = {
          #       frequency = 80.0;
          #       gain = 0.0;
          #       mode = "RLC (BT)";
          #       mute = false;
          #       q = 0.7;
          #       slope = "x2";
          #       solo = false;
          #       type = "Hi-pass";
          #       width = 4.0;
          #     };
          #     band1 = {
          #       frequency = 220.0;
          #       gain = -2.0;
          #       mode = "RLC (MT)";
          #       mute = false;
          #       q = 0.7;
          #       slope = "x1";
          #       solo = false;
          #       type = "Bell";
          #       width = 4.0;
          #     };
          #     band2 = {
          #       frequency = 350.0;
          #       gain = -2.0;
          #       mode = "BWC (MT)";
          #       mute = false;
          #       q = 1.2;
          #       slope = "x2";
          #       solo = false;
          #       type = "Bell";
          #       width = 4.0;
          #     };
          #     band3 = {
          #       frequency = 3500.0;
          #       gain = 2.0;
          #       mode = "BWC (BT)";
          #       mute = false;
          #       q = 0.9;
          #       slope = "x2";
          #       solo = false;
          #       type = "Bell";
          #       width = 4.0;
          #     };
          #     band4 = {
          #       frequency = 10000.0;
          #       gain = 2.0;
          #       mode = "LRX (MT)";
          #       mute = false;
          #       q = 0.7;
          #       slope = "x1";
          #       solo = false;
          #       type = "Hi-shelf";
          #       width = 4.0;
          #     };
          #   };
          #   mode = "IIR";
          #   num-bands = 5;
          #   output-gain = 0.0;
          #   pitch-left = 0.0;
          #   pitch-right = 0.0;
          #   right = {
          #     band0 = {
          #       frequency = 80.0;
          #       gain = 0.0;
          #       mode = "RLC (BT)";
          #       mute = false;
          #       q = 0.7;
          #       slope = "x2";
          #       solo = false;
          #       type = "Hi-pass";
          #       width = 4.0;
          #     };
          #     band1 = {
          #       frequency = 220.0;
          #       gain = -2.0;
          #       mode = "RLC (MT)";
          #       mute = false;
          #       q = 0.7;
          #       slope = "x1";
          #       solo = false;
          #       type = "Bell";
          #       width = 4.0;
          #     };
          #     band2 = {
          #       frequency = 350.0;
          #       gain = -2.0;
          #       mode = "BWC (MT)";
          #       mute = false;
          #       q = 1.2;
          #       slope = "x2";
          #       solo = false;
          #       type = "Bell";
          #       width = 4.0;
          #     };
          #     band3 = {
          #       frequency = 3500.0;
          #       gain = 2.0;
          #       mode = "BWC (BT)";
          #       mute = false;
          #       q = 0.9;
          #       slope = "x2";
          #       solo = false;
          #       type = "Bell";
          #       width = 4.0;
          #     };
          #     band4 = {
          #       frequency = 10000.0;
          #       gain = 2.0;
          #       mode = "LRX (MT)";
          #       mute = false;
          #       q = 0.7;
          #       slope = "x1";
          #       solo = false;
          #       type = "Hi-shelf";
          #       width = 4.0;
          #     };
          #   };
          #   split-channels = false;
          # };
          # "gate#0" = {
          #   attack = 5.0;
          #   bypass = false;
          #   curve-threshold = -50.0;
          #   curve-zone = -2.0;
          #   dry = -80.01;
          #   hpf-frequency = 10.0;
          #   hpf-mode = "Off";
          #   hysteresis = true;
          #   hysteresis-threshold = -3.0;
          #   hysteresis-zone = -1.0;
          #   input-gain = 0.0;
          #   input-to-link = 0.0;
          #   input-to-sidechain = 0.0;
          #   link-to-input = 0.0;
          #   link-to-sidechain = 0.0;
          #   lpf-frequency = 20000.0;
          #   lpf-mode = "Off";
          #   makeup = 1.0;
          #   output-gain = 0.0;
          #   reduction = -12.0;
          #   release = 250.0;
          #   sidechain = {
          #     lookahead = 0.0;
          #     mode = "RMS";
          #     preamp = 0.0;
          #     reactivity = 10.0;
          #     source = "Middle";
          #     stereo-split-source = "Left/Right";
          #     type = "Internal";
          #   };
          #   sidechain-to-input = 0.0;
          #   sidechain-to-link = 0.0;
          #   stereo-split = false;
          #   wet = -1.0;
          # };
          # "limiter#0" = {
          #   alr = false;
          #   alr-attack = 5.0;
          #   alr-knee = 0.0;
          #   alr-release = 50.0;
          #   attack = 2.0;
          #   bypass = false;
          #   dithering = "16bit";
          #   gain-boost = false;
          #   input-gain = 0.0;
          #   input-to-link = 0.0;
          #   input-to-sidechain = 0.0;
          #   link-to-input = 0.0;
          #   link-to-sidechain = 0.0;
          #   lookahead = 2.0;
          #   mode = "Herm Wide";
          #   output-gain = 0.0;
          #   oversampling = "None";
          #   release = 5.0;
          #   sidechain-preamp = 0.0;
          #   sidechain-to-input = 0.0;
          #   sidechain-to-link = 0.0;
          #   sidechain-type = "Internal";
          #   stereo-link = 100.0;
          #   threshold = -1.5;
          # };
          # plugins_order = [
          #   "rnnoise#0"
          #   "deepfilternet#0"
          #   "gate#0"
          #   "equalizer#0"
          #   "compressor#0"
          #   "deesser#0"
          #   "limiter#0"
          # ];
          # "rnnoise#0" = {
          #   bypass = false;
          #   enable-vad = false;
          #   input-gain = 0.0;
          #   model-name = ''""'';
          #   output-gain = 0.0;
          #   release = 20.0;
          #   use-standard-model = true;
          #   vad-thres = 30.0;
          #   wet = 0.0;
          # };
          # };
          # };
          # NOTE: Specific EQ for DT1990PRO
          # comment out if you aren't using these or add your own
          # https://autoeq.app/ -> select headphones
          headphones = {
            output = {
              blocklist = [ ];
              "equalizer#0" = {
                input-gain = -4.78;
                num-bands = 10;
                left = {
                  band0 = {
                    frequency = 105.0;
                    gain = 2.5;
                    mode = "BWC (BT)";
                    q = 0.70;
                    type = "Lo-shelf";
                  };
                  band1 = {
                    frequency = 192.1;
                    gain = -4.2;
                    mode = "BWC (BT)";
                    q = 0.83;
                    type = "Bell";
                  };
                  band2 = {
                    frequency = 1217.4;
                    gain = 1.5;
                    mode = "BWC (BT)";
                    q = 1.58;
                    type = "Bell";
                  };
                  band3 = {
                    frequency = 2334.6;
                    gain = 2.2;
                    mode = "BWC (BT)";
                    q = 0.62;
                    type = "Bell";
                  };
                  band4 = {
                    frequency = 3457.5;
                    gain = -2.2;
                    mode = "BWC (BT)";
                    q = 2.22;
                    type = "Bell";
                  };
                  band5 = {
                    frequency = 3818.6;
                    gain = 5.3;
                    mode = "BWC (BT)";
                    q = 1.24;
                    type = "Bell";
                  };
                  band6 = {
                    frequency = 4587.1;
                    gain = 1.5;
                    mode = "BWC (BT)";
                    q = 4.21;
                    type = "Bell";
                  };
                  band7 = {
                    frequency = 5126.7;
                    gain = -5.6;
                    mode = "BWC (BT)";
                    q = 4.17;
                    type = "Bell";
                  };
                  band8 = {
                    frequency = 8507.9;
                    gain = -3.6;
                    mode = "BWC (BT)";
                    q = 3.26;
                    type = "Bell";
                  };
                  band9 = {
                    frequency = 10000.0;
                    gain = -6.6;
                    mode = "BWC (BT)";
                    q = 0.70;
                    type = "Hi-shelf";
                  };
                };
                right = {
                  band0 = {
                    frequency = 105.0;
                    gain = 2.5;
                    mode = "BWC (BT)";
                    q = 0.70;
                    type = "Lo-shelf";
                  };
                  band1 = {
                    frequency = 192.1;
                    gain = -4.2;
                    mode = "BWC (BT)";
                    q = 0.83;
                    type = "Bell";
                  };
                  band2 = {
                    frequency = 1217.4;
                    gain = 1.5;
                    mode = "BWC (BT)";
                    q = 1.58;
                    type = "Bell";
                  };
                  band3 = {
                    frequency = 2334.6;
                    gain = 2.2;
                    mode = "BWC (BT)";
                    q = 0.62;
                    type = "Bell";
                  };
                  band4 = {
                    frequency = 3457.5;
                    gain = -2.2;
                    mode = "BWC (BT)";
                    q = 2.22;
                    type = "Bell";
                  };
                  band5 = {
                    frequency = 3818.6;
                    gain = 5.3;
                    mode = "BWC (BT)";
                    q = 1.24;
                    type = "Bell";
                  };
                  band6 = {
                    frequency = 4587.1;
                    gain = 1.5;
                    mode = "BWC (BT)";
                    q = 4.21;
                    type = "Bell";
                  };
                  band7 = {
                    frequency = 5126.7;
                    gain = -5.6;
                    mode = "BWC (BT)";
                    q = 4.17;
                    type = "Bell";
                  };
                  band8 = {
                    frequency = 8507.9;
                    gain = -3.6;
                    mode = "BWC (BT)";
                    q = 3.26;
                    type = "Bell";
                  };
                  band9 = {
                    frequency = 10000.0;
                    gain = -6.6;
                    mode = "BWC (BT)";
                    q = 0.70;
                    type = "Hi-shelf";
                  };
                };
              };
              plugins_order = [ "equalizer#0" ];
            };
          };
        };
      };
    };
}
