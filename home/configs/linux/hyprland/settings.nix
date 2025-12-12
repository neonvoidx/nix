{
  lib,
  hostname ? "",
  ...
}:
let
  isVoid = hostname == "void";
  isVoidFrame = hostname == "voidframe";
in
{
  # Input configuration
  input = {
    follow_mouse = 1;
    sensitivity = 0;
    scroll_factor = 1.0;
  };

  # General configuration
  general = {
    gaps_in = 5;
    gaps_out = 8;
    border_size = 3;
    "col.active_border" = "rgb(37f499) rgb(04d1f9) 90deg";
    "col.inactive_border" = "rgb(a48cf2)";
    "col.nogroup_border" = "rgb(a48cf2)";
    "col.nogroup_border_active" = "rgba(36F498FF)";
    resize_on_border = true;
    layout = "master";
    extend_border_grab_area = 3;
    hover_icon_on_border = false;
  };

  # Animations
  animations = {
    enabled = true;
    workspace_wraparound = true;
    bezier = [
      "easeOutCubic,0.65,0,0.35,0.8"
      "easeInOut,0.42,0,0.58,0.8"
      "overshoot,0.05,0.9,0.1,0.8"
    ];
    animation = [
      "windows,1,4,default,popin"
      "layers,0"
      "workspaces,1,3,default,slide"
    ];
  };

  # Dwindle layout
  dwindle = {
    pseudotile = true;
    preserve_split = true;
    force_split = 2;
    default_split_ratio = 1;
  };

  # Master layout
  master = {
    new_status = "slave";
    new_on_top = false;
    allow_small_split = false;
    mfact = 0.58;
  };

  # Decoration
  decoration = {
    rounding = 8;
    dim_inactive = true;
    dim_strength = 5.0e-2;

    blur = {
      enabled = true;
      size = 8;
      passes = 1;
      new_optimizations = true;
      ignore_opacity = true;
      xray = true;
    };

    shadow = {
      enabled = true;
      range = 4;
      render_power = 3;
      ignore_window = true;
      color = "rgb(212337)";
    };
  };

  # Rendering
  render = {
    direct_scanout = 2;
    cm_enabled = true;
    cm_fs_passthrough = 2;
    cm_auto_hdr = 0;
    cm_sdr_eotf = 0;
  };

  # Experimental features
  experimental = {
    xx_color_management_v4 = true;
  };

  # Miscellaneous
  misc = {
    disable_hyprland_logo = false;
    animate_manual_resizes = true;
    focus_on_activate = true;
    mouse_move_enables_dpms = true;
    key_press_enables_dpms = true;
    session_lock_xray = true;
  };

  # Xwayland
  xwayland = {
    force_zero_scaling = true;
  };

  # Debug
  debug = {
    disable_logs = true;
  };

  # Ecosystem
  ecosystem = {
    no_update_news = true;
    no_donation_nag = true;
  };

  # Cursor
  cursor = {
    sync_gsettings_theme = true;
    no_break_fs_vrr = 1;
    enable_hyprcursor = true;
  }
  // lib.optionalAttrs isVoid { default_monitor = "DP-2"; };
}
