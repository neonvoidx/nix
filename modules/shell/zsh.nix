{ den, ... }:
{
  den.aspects.zsh = {
    nixos =
      { ... }:
      {
        programs.zsh.enable = true;
        environment.pathsToLink = [ "/share/zsh" ];
      };

    homeManager =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        c = config.lib.stylix.colors;
      in
      {
        programs.zsh = {
          enable = true;

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

          historySubstringSearch.enable = true;

          autosuggestion = {
            enable = true;
            strategy = [
              "history"
              "completion"
              "match_prev_cmd"
            ];
          };

          enableCompletion = true;

          completionInit = ''
            autoload -Uz compinit
            compinit

            if (( $+functions[enable-fzf-tab] )); then
              enable-fzf-tab
            fi
          '';

          antidote = {
            enable = true;
            plugins = [
              "Aloxaf/fzf-tab"
              "trystan2k/zsh-tab-title"
              "zdharma-continuum/fast-syntax-highlighting"
              "ohmyzsh/ohmyzsh path:plugins/colored-man-pages"
              "ohmyzsh/ohmyzsh path:plugins/fancy-ctrl-z"
              "zsh-users/zsh-completions"
              "jeffreytse/zsh-vi-mode kind:defer"
            ];
          };

          sessionVariables = {
            ZSH_AUTOSUGGEST_STRATEGY = "history completion match_prev_cmd";
            ZSH_DISABLE_COMPFIX = "true";
            NODE_OPTIONS = "--max-old-space-size=8192";
            DISABLE_AUTO_TITLE = "true";
            ZSH_TAB_TITLE_DISABLE_AUTO_TITLE = "false";
            ZSH_TAB_TITLE_ONLY_FOLDER = "true";
            ZSH_TAB_TITLE_CONCAT_FOLDER_PROCESS = "true";
            FZF_PREVIEW_ADVANCED = "bat";
            FZF_DEFAULT_OPTS = "--color=fg:#${c.base05},bg:#${c.base00},hl:#${c.base0B} --color=fg+:#${c.base05},bg+:#${c.base01},hl+:#${c.base0B} --color=info:#${c.base0A},prompt:#${c.base0C},pointer:#${c.base0D} --color=marker:#${c.base0D},spinner:#${c.base0A},header:#${c.base03} --height 80% --layout reverse --border";
            FZF_PATH = "${config.home.homeDirectory}/.config/fzf";
            _ZO_EXCLUDE_DIRS = "/Applications/**:**/node_modules";
            _ZO_RESOLVE_SYMLINKS = "0";
            FZF_CTRL_T_COMMAND = "";
            FNM_DIR = "${config.home.homeDirectory}/.cache/fnm";
            PYENV_ROOT = "${config.home.homeDirectory}/.pyenv";
            CMAKE_PREFIX_PATH = "/usr/local:$CMAKE_PREFIX_PATH";
            LD_LIBRARY_PATH = "/usr/local/lib:$LD_LIBRARY_PATH";
            ZVM_SYSTEM_CLIPBOARD_ENABLED = "true";
            LS_COLORS = "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:";
            XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
            EDITOR = if config.programs.neovim.enable or false then "nvim" else "vi";
            VISUAL = if config.programs.neovim.enable or false then "nvim" else "vi";
          };

          shellAliases = {
            dev = "cd ~/dev";
            findhere = "find . -name";
            e = "nvim";
          };

          setOptions = [
            "promptsubst"
            "BANG_HIST"
            "HIST_REDUCE_BLANKS"
            "HIST_VERIFY"
            "HIST_BEEP"
            "HIST_FIND_NO_DUPS"
            "HIST_SAVE_NO_DUPS"
          ];

          siteFunctions = {
            findsyms = # bash
              ''
                local search_path="''${1:-.}"
                find "$search_path" -type l -ls
              '';

            deleteall = # bash
              ''
                find . -name "$1" -exec rm -rf {} \;
              '';

            y = # bash
              ''
                local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
                yazi "$@" --cwd-file="$tmp"
                if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                  builtin cd -- "$cwd"
                fi
                rm -f -- "$tmp"
              '';

            kk =
              lib.mkIf config.programs.kitty.enable # bash
                ''
                  kitten @ send-text --match-tab state:focused $1 && kitten @ send-key --match-tab state:focused Enter
                '';

            reload-ssh = # bash
              ''
                ssh-add -e /usr/local/lib/opensc-pkcs11.so >> /dev/null
                if [ $? -gt 0 ]; then
                  echo "Failed to remove previous card"
                fi
                ssh-add -s /usr/local/lib/opensc-pkcs11.so
              '';

            timezsh = # bash
              ''
                shell=''${1-$SHELL}
                for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
              '';

            ffmpeg-downsize = # bash
              ''
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

            ffmpeg-togif = # bash
              ''
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

            yy = # bash
              ''
                local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
                yazi "$@" --cwd-file="$tmp"
                if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                  cd -- "$cwd"
                fi
                rm -f -- "$tmp"
              '';

            skill = # bash
              ''
                local selected pid
                selected=$(ps aux | awk 'NR>1 {printf "%-8s  %-s\n", $2, $11}' \
                  | fzf --prompt="☠ Kill: " --header="PID       NAME")
                [ -z "$selected" ] || {
                  pid=$(echo "$selected" | awk '{print $1}')
                  kill -9 "$pid" && echo "Killed PID $pid"
                }
              '';
          };

          initContent =
            lib.mkBefore # bash
              ''
                zmodload zsh/nearcolor

                ZVM_INIT_MODE=sourcing

                zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
                zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
                zstyle ':completion:*' menu no

                zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd $realpath'
                zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd $realpath'
                zstyle ':fzf-tab:*' fzf-command fzf

                function zvm_after_lazy_keybindings_setup() {
                  bindkey '^I' fzf-tab-complete
                }

                # zsh-vi-mode resets bindings and options when it deferred-loads;
                # restore fzf Ctrl+R and history persistence after it finishes.
                function zvm_after_init() {
                  bindkey '^R' fzf-history-widget
                  setopt SHARE_HISTORY INC_APPEND_HISTORY HIST_REDUCE_BLANKS
                }

                if command -v cmake &> /dev/null && command -v ninja &> /dev/null; then
                  alias cmakeninja='cmake -S . -B build -G Ninja'
                fi

                if [ -f ~/.ssh/scm-script.sh ]; then
                  alias scm-ssh='bash ~/.ssh/scm-script.sh'
                  scm-ssh start_agent >/dev/null 2>&1
                fi

                [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

                if [ -z "$SSH_AUTH_SOCK" ]; then
                  eval $(ssh-agent -s) > /dev/null
                fi
                ssh-add -l &>/dev/null || ssh-add ~/.ssh/id_ed25519 2>/dev/null

                setopt SHARE_HISTORY INC_APPEND_HISTORY

                eval "$(devenv hook zsh)"
              '';
        };
      };
  };
}
