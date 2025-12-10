{ config, pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;

    # History configuration
    history = {
      size = 10000000;
      save = 10000000;
      path = "${config.home.homeDirectory}/.zsh_history";
      extended = true;
      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    # Additional history options
    historySubstringSearch.enable = true;

    # Auto-suggestions
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" "match_prev_cmd" ];
    };

    # Syntax highlighting
    syntaxHighlighting.enable = true;

    # Enable completion
    enableCompletion = true;

    # Completion settings
    completionInit = ''
      autoload -Uz compinit
      compinit
      setopt promptsubst
    '';

    # Environment variables
    sessionVariables = {
      ZSH_AUTOSUGGEST_STRATEGY = "history completion match_prev_cmd";
      ZSH_DISABLE_COMPFIX = "true";
      NODE_OPTIONS = "--max-old-space-size=8192";
      DISABLE_AUTO_TITLE = "true";
      ZSH_TAB_TITLE_DISABLE_AUTO_TITLE = "false";
      ZSH_TAB_TITLE_ONLY_FOLDER = "true";
      ZSH_TAB_TITLE_CONCAT_FOLDER_PROCESS = "true";
      FZF_PREVIEW_ADVANCED = "bat";
      FZF_DEFAULT_OPTS =
        "--color=fg:#ebfafa,bg:#282a36,hl:#37f499 --color=fg+:#ebfafa,bg+:#212337,hl+:#37f499 --color=info:#f7c67f,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449 --height 80% --layout reverse --border";
      FZF_PATH = "${config.home.homeDirectory}/.config/fzf";
      _ZO_EXCLUDE_DIRS = "/Applications/**:**/node_modules";
      _ZO_RESOLVE_SYMLINKS = "0";
      FZF_CTRL_T_COMMAND = "";
      FNM_DIR = "${config.home.homeDirectory}/.cache/fnm";
      PYENV_ROOT = "${config.home.homeDirectory}/.pyenv";
      CMAKE_PREFIX_PATH = "/usr/local:$CMAKE_PREFIX_PATH";
      LD_LIBRARY_PATH = "/usr/local/lib:$LD_LIBRARY_PATH";
      ZVM_SYSTEM_CLIPBOARD_ENABLED = "true";
      PURE_PROMPT_SYMBOL = "󰤇 ";
      PURE_CMD_MAX_EXEC_TIME = "0";
      LS_COLORS =
        "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      EDITOR = if config.programs.neovim.enable or false then "nvim" else "vi";
      VISUAL = if config.programs.neovim.enable or false then "nvim" else "vi";
    };

    # Shell aliases
    shellAliases = {
      hypr = "e ~/.config/hypr/hyprland.conf";
      yay = "paru";
      dev = "cd ~/dev";
      findhere = "find . -name";
      e = "nvim";
      lg = lib.mkIf (pkgs ? lazygit) "lazygit";
      ly = lib.mkIf (pkgs ? lazygit)
        "lazygit --work-tree ~/dotfiles --git-dir ~/dotfiles/.git";
      s = lib.mkIf config.programs.kitty.enable "kitten ssh";
      icat = lib.mkIf config.programs.kitty.enable "kitten icat";
      ssh = lib.mkIf config.programs.kitty.enable "kitten ssh";
      d = lib.mkIf config.programs.kitty.enable "kitten diff";
      ls = lib.mkIf (pkgs ? lsd) "lsd";
      l = lib.mkIf (pkgs ? lsd) "ls -Al";
      lt = lib.mkIf (pkgs ? lsd) "ls --tree --ignore-glob=node_modules";
      cat = lib.mkIf config.programs.bat.enable "bat";
      pacq = lib.mkIf pkgs.stdenv.isLinux "~/scripts/fzfpac.sh";
      htop = lib.mkIf (pkgs ? btop) "btop";
      top = lib.mkIf (pkgs ? btop) "btop";
      brewup = lib.mkIf pkgs.stdenv.isDarwin
        "brew upgrade && cd ~/.config/brew && ./brewbackup.sh";
      eup =
        "nvim --headless '+Lazy! sync' +qa && cd ~/.config/nvim && git add . && git commit -m 'upd' && git push";
    };

    # Shell functions
    functions = {
      _fzf_compgen_path = ''
        fd --hidden --follow . "$1"
      '';

      _fzf_compgen_dir = ''
        fd --type d --hidden --follow . "$1"
      '';

      findsyms = ''
        local search_path="''${1:-.}"
        find "$search_path" -type l -ls
      '';

      deleteall = ''
        find . -name "$1" -exec rm -rf {} \;
      '';

      y = ''
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      '';

      yy = ''
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      '';

      kk = lib.mkIf config.programs.kitty.enable ''
        kitten @ send-text --match-tab state:focused $1 && kitten @ send-key --match-tab state:focused Enter
      '';

      reload-ssh = ''
        ssh-add -e /usr/local/lib/opensc-pkcs11.so >> /dev/null
        if [ $? -gt 0 ]; then
          echo "Failed to remove previous card"
        fi
        ssh-add -s /usr/local/lib/opensc-pkcs11.so
      '';

      timezsh = ''
        shell=''${1-$SHELL}
        for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
      '';

      ffmpeg-downsize = ''
        if ! command -v ffmpeg &> /dev/null; then
          echo "ffmpeg not found. Please install ffmpeg."
          return 1
        fi
        if [ $# -eq 0 ]; then
          echo "Usage: movconvert <inputfile.mov>"
          return 1
        fi
        local output="''${1%.*}"
        ffmpeg -i "$1" -c:v libx264 -c:a copy -crf 20 "''${output}-small.mov"
      '';

      ffmpeg-togif = ''
        if ! command -v ffmpeg &> /dev/null; then
          echo "ffmpeg not found. Please install ffmpeg."
          return 1
        fi
        if [ $# -ne 3 ]; then
          echo "Usage: togif <input.mp4> <start_time> <duration>"
          echo "Example: togif movie.mp4 6 8.8"
          return 1
        fi
        local input="$1"
        local start="$2"
        local duration="$3"
        local base="''${input%.mp4}"
        ffmpeg -ss "$start" -t "$duration" -i "$input" -vf "fps=30,scale=400:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "''${base}.gif"
      '';
    };

    # Shell functions and init extra
    initExtra = ''
      # Hex color support
      zmodload zsh/nearcolor

      # History options
      setopt BANG_HIST
      setopt HIST_REDUCE_BLANKS
      setopt HIST_VERIFY
      setopt HIST_BEEP
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS

      # Completion bindings
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd $realpath'

      # Pure Prompt colors
      zstyle :prompt:pure:git:arrow color "#f16c75"
      zstyle :prompt:pure:git:branch color "#04d1f9"
      zstyle :prompt:pure:path color "#37f499"
      zstyle :prompt:pure:prompt:error color "#f16c75"
      zstyle :prompt:pure:prompt:success color "#37f499"
      zstyle :prompt:pure:prompt:continuation color "#f7c67f"
      zstyle :prompt:pure:suspended_jobs color "#f16c75"
      zstyle :prompt:pure:user color "#a48cf2"
      zstyle :prompt:pure:user:root color "#f1fc79"

      # FZF functions
      _fzf_compgen_path() {
        fd --hidden --follow . "$1"
      }
      _fzf_compgen_dir() {
        fd --type d --hidden --follow . "$1"
      }

      # Functions
      findsyms() {
        local search_path="''${1:-.}"
        find "$search_path" -type l -ls
      }

      deleteall() {
        find . -name "$1" -exec rm -rf {} \;
      }

      y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      ${lib.optionalString config.programs.kitty.enable ''
        kk() {
          kitten @ send-text --match-tab state:focused $1 && kitten @ send-key --match-tab state:focused Enter
        }
      ''}

      reload-ssh() {
        ssh-add -e /usr/local/lib/opensc-pkcs11.so >> /dev/null
        if [ $? -gt 0 ]; then
          echo "Failed to remove previous card"
        fi
        ssh-add -s /usr/local/lib/opensc-pkcs11.so
      }

      timezsh() {
        shell=''${1-$SHELL}
        for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
      }

      ffmpeg-downsize() {
        if ! command -v ffmpeg &> /dev/null; then
          echo "ffmpeg not found. Please install ffmpeg."
          return 1
        fi
        if [ $# -eq 0 ]; then
          echo "Usage: movconvert <inputfile.mov>"
          return 1
        fi
        local output="''${1%.*}"
        ffmpeg -i "$1" -c:v libx264 -c:a copy -crf 20 "''${output}-small.mov"
      }

      _ffmpeg_downsize() {
        _arguments '*:input file:_files'
      }
      compdef _ffmpeg_downsize ffmpeg-downsize

      ffmpeg-togif() {
        if ! command -v ffmpeg &> /dev/null; then
          echo "ffmpeg not found. Please install ffmpeg."
          return 1
        fi
        if [ $# -ne 3 ]; then
          echo "Usage: togif <input.mp4> <start_time> <duration>"
          echo "Example: togif movie.mp4 6 8.8"
          return 1
        fi
        local input="$1"
        local start="$2"
        local duration="$3"
        local base="''${input%.mp4}"
        ffmpeg -ss "$start" -t "$duration" -i "$input" -vf "fps=30,scale=400:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "''${base}.gif"
      }

      _ffmpeg_togif() {
        _arguments \
          '1:input file:_files' \
          '2:start time (seconds):' \
          '3:duration (seconds):'
      }
      compdef _ffmpeg_togif ffmpeg-togif

      yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      ${lib.optionalString pkgs.stdenv.isLinux ''
        if command -v wslu &> /dev/null; then
          export BROWSER=wslview
        fi
      ''}

      # GH CLI Copilot
      COPILOT_CLI=~/.local/share/gh/extensions/gh-copilot/gh-copilot
      if [ -f "$COPILOT_CLI" ]; then
        eval "$(gh copilot alias -- zsh)"
      else
        if command -v gh &> /dev/null; then
          gh extension install github/gh-copilot 2>/dev/null || true
        fi
      fi

      # GH CLI clone-org
      CLONE_ORG=~/.local/share/gh/extensions/gh-clone-org/gh-clone-org
      if [ ! -f "$CLONE_ORG" ] && command -v gh &> /dev/null; then
        gh extension install matt-bartel/gh-clone-org 2>/dev/null || true
      fi

      if command -v cmake &> /dev/null && command -v ninja &> /dev/null; then
        alias cmakeninja='cmake -S . -B build -G Ninja'
      fi

      # Eval & Source
      ${lib.optionalString (pkgs ? pay-respects) ''
        eval "$(pay-respects zsh --alias)"
      ''}

      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

      ${lib.optionalString (pkgs ? fnm) ''
        export PATH="$HOME/.local/share/fnm:$PATH"
        eval "$(fnm env --use-on-cd --shell zsh --fnm-dir ~/.cache/fnm)"
      ''}

      # SSH agent start if necessary
      if [ -z $SSH_AGENT_PID ] && [ -z $SSH_TTY ]; then
        eval `ssh-agent -s` > /dev/null
      fi

      if [ -f ~/.ssh/scm-script.sh ]; then
        alias scm-ssh='bash ~/.ssh/scm-script.sh'
        scm-ssh start_agent >/dev/null 2>&1
      fi

      [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

      ${lib.optionalString config.programs.zoxide.enable ''
        eval "$(zoxide init zsh --cmd cd --hook pwd)"
      ''}

      ${lib.optionalString (pkgs ? fastfetch) ''
        if command -v fastfetch &> /dev/null; then
          fastfetch
        fi
      ''}

      ${lib.optionalString pkgs.stdenv.isDarwin ''
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      ''}
    '';

    # Zinit plugin manager (managed manually via initExtraFirst)
    initExtraFirst = ''
      # Zinit
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
      [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      source "''${ZINIT_HOME}/zinit.zsh"
      autoload -Uz _zinit
      (( ''${+_comps} )) && _comps[zinit]=_zinit

      # Zinit Packages
      zinit wait lucid light-mode for \
        pick"async.sh" src"pure.zsh" wait"!0" sindresorhus/pure \
          Aloxaf/fzf-tab \
          trystan2k/zsh-tab-title \
        atinit"zicompinit; zicdreplay" \
          zdharma-continuum/fast-syntax-highlighting \
          OMZP::colored-man-pages \
          OMZP::fancy-ctrl-z \
        atload"_zsh_autosuggest_start" \
          zsh-users/zsh-autosuggestions \
        blockf atpull'zinit creinstall -q .' \
          zsh-users/zsh-completions
      zinit ice depth=1
      zinit light jeffreytse/zsh-vi-mode
      zinit ice wait lucid light-mode
    '';

    # Profile options (commented out by default)
    profileExtra = ''
      # Uncomment to profile
      # zmodload zsh/zprof
    '';

    loginExtra = ''
      # Uncomment to profile
      # zprof
    '';
  };

  # Additional PATH entries
  home.sessionPath = [
    "$HOME/.yarn/bin"
    "$HOME/.cargo/bin"
    "$HOME/.rd/bin"
    "$HOME/dev/bin"
    "$HOME/.local/bin"
    "$HOME/go/bin"
  ] ++ lib.optionals pkgs.stdenv.isDarwin [ "/Applications/flameshot.app/" ];
}
