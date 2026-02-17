{ ... }:
{
  flake.modules.homeManager.tv =
    { ... }@args:
    {
      programs = {
        television = {
          enable = true;
          enableZshIntegration = true;
          channels = {
            alias = {
              metadata = {
                name = "alias";
                description = "A channel to select from your shell aliases";
              };
              source = {
                command = "alias";
                display = "{split:=:0}";
                output = "{split:=:1..}";
              };
            };

            channels = {
              metadata = {
                name = "channels";
                description = "A channel to select from your television channels";
                requirements = [ "fd" ];
              };
              source = {
                command = "fd -e toml . ~/.config/television/cable";
                display = "{split:/:-1|split:.:0}";
                output = "{split:/:-1|split:.:0}";
              };
              preview = {
                command = "cat ~/.config/television/cable/{}.toml";
              };
            };

            dirs = {
              metadata = {
                name = "dirs";
                description = "A channel to select from your directory stack";
              };
              source = {
                command = "dirs -v";
                display = "{trim|split:\t:1}";
                output = "{trim|split:\t:1}";
              };
            };

            docker-images = {
              metadata = {
                name = "docker-images";
                description = "A channel to select from your Docker images";
                requirements = [ "docker" ];
              };
              source = {
                command = "docker images --format '{{.Repository}}:{{.Tag}} {{.ID}} {{.Size}}'";
                display = "{0} ({2})";
                output = "{1}";
              };
              preview = {
                command = "docker inspect {1}";
              };
            };

            dotfiles = {
              metadata = {
                name = "dotfiles";
                description = "A channel to select files from your dotfiles directory";
              };
              source = {
                command = "fd -H -t f . ~/dotfiles";
              };
              preview = {
                command = "bat -n --color=always '{}'";
              };
            };

            env = {
              metadata = {
                name = "env";
                description = "A channel to select from your environment variables";
              };
              source = {
                command = "env | sort";
                display = "{split:=:0}";
              };
              preview = {
                command = "echo \"\${}\"";
              };
            };

            files = {
              metadata = {
                name = "files";
                description = "A channel to preview files found by fd";
                requirements = [
                  "fd"
                  "bat"
                ];
              };
              source = {
                command = [
                  "fd -t f -H -E .git"
                  "fd -t f -H"
                ];
              };
              preview = {
                command = "bat -n --color=always '{}'";
              };
              keybindings = {
                enter = "actions:open";
              };
              actions = {
                open = {
                  description = "Open the selected file";
                  command = "$EDITOR '{}'";
                  mode = "execute";
                };
              };
            };

            gh-issues = {
              metadata = {
                name = "gh-issues";
                description = ''
                  A channel to browse and manage GitHub issues

                  The first source lists open issues, the second closed, and the third both.

                  Keybindings

                  Press `ctrl-o` to open the selected issue in the browser.
                  Press `ctrl-c` to close or reopen the selected issue.
                '';
                requirements = [ "gh" ];
              };
              source = {
                command = [
                  "gh issue list --limit 1000 | awk '{print $1, substr($0, index($0,$2))}'"
                  "gh issue list --limit 1000 --state closed | awk '{print $1, substr($0, index($0,$2))}'"
                  "gh issue list --limit 1000 --state all | awk '{print $1, substr($0, index($0,$2))}'"
                ];
                output = "{0}";
                ansi = true;
              };
              preview = {
                command = "gh issue view {0}";
              };
              keybindings = {
                ctrl-o = "actions:open";
                ctrl-c = [
                  "actions:close"
                  "reload_source"
                ];
              };
              actions = {
                open = {
                  description = "Open the selected issue in the browser";
                  command = "gh issue view {0} --web";
                  mode = "fork";
                };
                close = {
                  description = "Close or reopen the selected issue";
                  command = "gh issue close {0} 2>/dev/null || gh issue reopen {0}";
                  mode = "fork";
                };
              };
            };

            gh-prs = {
              metadata = {
                name = "gh-prs";
                description = ''
                  A channel to browse and manage GitHub pull requests

                  The first source lists open PRs, the second closed, the third merged, and the fourth all.

                  Keybindings

                  Press `ctrl-o` to open the selected PR in the browser.
                  Press `ctrl-c` to close or reopen the selected PR.
                  Press `ctrl-m` to merge the selected PR.
                  Press `ctrl-r` to checkout the PR branch and reload source.
                '';
                requirements = [ "gh" ];
              };
              source = {
                command = [
                  "gh pr list --limit 1000 | awk '{print $1, substr($0, index($0,$2))}'"
                  "gh pr list --limit 1000 --state closed | awk '{print $1, substr($0, index($0,$2))}'"
                  "gh pr list --limit 1000 --state merged | awk '{print $1, substr($0, index($0,$2))}'"
                  "gh pr list --limit 1000 --state all | awk '{print $1, substr($0, index($0,$2))}'"
                ];
                output = "{0}";
                ansi = true;
              };
              preview = {
                command = "gh pr view {0}";
              };
              keybindings = {
                ctrl-o = "actions:open";
                ctrl-c = [
                  "actions:close"
                  "reload_source"
                ];
                ctrl-m = [
                  "actions:merge"
                  "reload_source"
                ];
                ctrl-r = [
                  "actions:checkout"
                  "reload_source"
                ];
              };
              actions = {
                open = {
                  description = "Open the selected PR in the browser";
                  command = "gh pr view {0} --web";
                  mode = "fork";
                };
                close = {
                  description = "Close or reopen the selected PR";
                  command = "gh pr close {0} 2>/dev/null || gh pr reopen {0}";
                  mode = "fork";
                };
                merge = {
                  description = "Merge the selected PR";
                  command = "gh pr merge {0} --squash --delete-branch";
                  mode = "fork";
                };
                checkout = {
                  description = "Checkout the PR branch";
                  command = "gh pr checkout {0}";
                  mode = "fork";
                };
              };
            };

            git-branch = {
              metadata = {
                name = "git-branch";
                description = "A channel to select and switch git branches";
                requirements = [ "git" ];
              };
              source = {
                command = "git branch -a";
                display = "{trim}";
                output = "{trim}";
              };
              preview = {
                command = "git log --oneline --graph --date=short --pretty='format:%C(auto)%cd %h%d %s' {trim} | head -n 200";
              };
            };

            git-diff = {
              metadata = {
                name = "git-diff";
                description = "A channel to select files from git diff commands";
                requirements = [ "git" ];
              };
              source = {
                command = "git diff --name-only HEAD";
              };
              preview = {
                command = "git diff HEAD --color=always -- '{}'";
              };
            };

            git-log = {
              metadata = {
                name = "git-log";
                description = "A channel to select and view git log entries";
                requirements = [ "git" ];
              };
              source = {
                command = "git log --oneline --all";
                display = "{split: :0}  {split: :1..}";
                output = "{split: :0}";
              };
              preview = {
                command = "git show --color=always {split: :0}";
              };
            };

            git-reflog = {
              metadata = {
                name = "git-reflog";
                description = "A channel to select from the git reflog";
                requirements = [ "git" ];
              };
              source = {
                command = "git reflog";
                display = "{split: :0}  {split: :1..}";
                output = "{split: :0}";
              };
              preview = {
                command = "git show --color=always {split: :0}";
              };
            };

            git-repos = {
              metadata = {
                name = "git-repos";
                description = "A channel to select from your git repositories";
                requirements = [
                  "fd"
                  "dirname"
                ];
              };
              source = {
                command = "fd -g .git -HL -t d -d 10 --prune ~ -E 'Library' -E 'Application Support' --exec dirname '{}'";
                display = "{split:/:-1}";
              };
              preview = {
                command = "cd '{}'; git log -n 200 --pretty=medium --all --graph --color";
              };
            };

            just-recipes = {
              metadata = {
                name = "just-recipes";
                description = "A channel to select recipes from Justfiles";
                requirements = [ "just" ];
              };
              source = {
                command = [ "just --summary | tr '[:blank:]' '\n'" ];
              };
              preview = {
                command = "just -s {}";
              };
              keybindings = {
                ctrl-x = "actions:execute-recipe";
              };
              actions = {
                execute-recipe = {
                  description = "Execute a justfile recipe";
                  command = "just {}";
                  mode = "execute";
                };
              };
            };

            man-pages = {
              metadata = {
                name = "man-pages";
                description = "Browse and preview system manual pages";
                requirements = [
                  "apropos"
                  "man"
                  "col"
                ];
              };
              source = {
                command = "apropos .";
              };
              preview = {
                command = "man '{0}' | col -bx";
                env = {
                  MANWIDTH = "80";
                };
              };
              keybindings = {
                enter = "actions:open";
              };
              actions = {
                open = {
                  description = "Open the selected man page in the system pager";
                  command = "man '{0}'";
                  mode = "execute";
                };
              };
              ui = {
                preview_panel = {
                  header = "{0}";
                };
              };
            };

            path = {
              metadata = {
                name = "path";
                description = "Investigate PATH contents";
                requirements = [
                  "fd"
                  "bat"
                ];
              };
              source = {
                command = "printf '%s\n' \"$PATH\" | tr ':' '\n'";
              };
              preview = {
                command = "fd -tx -d1 . \"{}\" -X printf \"%s\n\" \"{/}\" | sort -f | bat -n --color=always";
              };
            };

            procs = {
              metadata = {
                name = "procs";
                description = "A channel to find and manage running processes";
                requirements = [
                  "ps"
                  "awk"
                ];
              };
              source = {
                command = "ps -e -o pid=,ucomm= | awk '{print $1, $2}'";
                display = "{split: :1}";
                output = "{split: :0}";
              };
              preview = {
                command = "ps -p '{split: :0}' -o user,pid,ppid,state,%cpu,%mem,command | fold";
              };
              actions = {
                kill = {
                  description = "Kill the selected process (SIGKILL)";
                  command = "kill -9 {split: :0}";
                  mode = "execute";
                };
              };
              keybindings = {
                ctrl-k = "actions:kill";
              };
            };

            ssh-hosts = {
              metadata = {
                name = "ssh-hosts";
                description = "A channel to select hosts from your SSH config";
                requirements = [
                  "grep"
                  "tr"
                  "cut"
                ];
              };
              source = {
                command = "grep -E '^Host(name)? ' $HOME/.ssh/config | tr -s ' ' | cut -d' ' -f2- | tr ' ' '\n' | grep -v '^$'";
              };
            };

            text = {
              metadata = {
                name = "text";
                description = "A channel to find and select text from files";
                requirements = [
                  "rg"
                  "bat"
                ];
              };
              source = {
                command = "rg . --no-heading --line-number --colors 'match:fg:white' --colors 'path:fg:blue' --color=always";
                ansi = true;
                output = "{strip_ansi|split:\\::..2}";
              };
              preview = {
                command = "bat -n --color=always '{strip_ansi|split:\\::0}'";
                env = {
                  BAT_THEME = "ansi";
                };
                offset = "{strip_ansi|split:\\::1}";
              };
              ui = {
                preview_panel = {
                  header = "{strip_ansi|split:\\::..2}";
                };
              };
            };

            tldr = {
              metadata = {
                name = "tldr";
                description = "Browse and preview TLDR help pages for command-line tools";
                requirements = [ "tldr" ];
              };
              source = {
                command = "tldr --list";
              };
              preview = {
                command = "tldr '{0}'";
              };
              keybindings = {
                ctrl-e = "actions:open";
              };
              actions = {
                open = {
                  description = "Open the selected TLDR page";
                  command = "tldr '{0}'";
                  mode = "execute";
                };
              };
            };

            unicode = {
              metadata = {
                name = "unicode";
                description = ''
                  Search and insert unicode characters

                  The UnicodeData.txt file is included by many packages.

                  In addition to:

                  Alpine Linux: unicode-character-database
                  Arch: unicode-character-database
                  Debian/Ubuntu: unicode-data
                  Fedora / RHEL / CentOS unicode-ucd
                  Gentoo: app-i18n/unicode-data
                  NixOS: unicode/unicode-data
                  openSUSE: unicode-ucd

                  UnicodData.txt may also aleady be provided by:

                  1) Many java packages
                  2) Latex packages
                  3) Still others

                  It may in some cases be necessary to alter UNICODE_FILE below.

                '';
                requirements = [
                  "awk"
                  "perl"
                ];
              };
              source = {
                command = ''
                  UNICODE_FILE="/usr/share/unicode/ucd/UnicodeData.txt"
                  awk -F';' '
                    $2 !~ /^</ { print $1 "|" $2 }
                  ' "$UNICODE_FILE" | perl -CS -F'\|' -lane '
                      $code = $F[0];
                      $desc = $F[1];
                      $char = chr(hex($code));
                      print "U+$code|$char|$desc" if $char =~ /\p{Print}/;
                  '
                '';
                display = "{split:|:0}    {split:|:1}    {split:|:2}";
                output = "{split:|:1}";
              };
            };

            zsh-history = {
              metadata = {
                name = "zsh-history";
                description = "A channel to select from your zsh history";
                requirements = [ "zsh" ];
              };
              source = {
                command = "sed '1!G;h;$!d' \${HISTFILE:-\${HOME}/.zsh_history}";
                display = "{split:;:1..}";
                output = "{split:;:1..}";
              };
            };
          };
          settings = {
            tick_rate = 50;
            default_channel = "files";
            history_size = 1000;
            global_history = false;

            ui = {
              ui_scale = 100;
              orientation = "landscape";
              theme = "default";

              input_bar = {
                position = "top";
                prompt = ">";
                border_type = "rounded";
              };

              status_bar = {
                separator_open = "";
                separator_close = "";
                hidden = false;
              };

              results_panel = {
                border_type = "rounded";
              };

              preview_panel = {
                size = 50;
                scrollbar = true;
                border_type = "rounded";
                hidden = false;
              };

              help_panel = {
                show_categories = true;
                hidden = true;
              };

              remote_control = {
                show_channel_descriptions = true;
                sort_alphabetically = true;
              };
            };

            keybindings = {
              esc = "quit";
              ctrl-c = "quit";
              down = "select_next_entry";
              ctrl-n = "select_next_entry";
              ctrl-j = "select_next_entry";
              up = "select_prev_entry";
              ctrl-p = "select_prev_entry";
              ctrl-k = "select_prev_entry";
              ctrl-up = "select_prev_history";
              ctrl-down = "select_next_history";
              tab = "toggle_selection_down";
              backtab = "toggle_selection_up";
              enter = "confirm_selection";
              pagedown = "scroll_preview_half_page_down";
              pageup = "scroll_preview_half_page_up";
              ctrl-y = "copy_entry_to_clipboard";
              ctrl-r = "reload_source";
              ctrl-s = "cycle_sources";
              ctrl-t = "toggle_remote_control";
              ctrl-o = "toggle_preview";
              ctrl-h = "toggle_help";
              f12 = "toggle_status_bar";
              ctrl-l = "toggle_layout";
              backspace = "delete_prev_char";
              ctrl-w = "delete_prev_word";
              ctrl-u = "delete_line";
              delete = "delete_next_char";
              left = "go_to_prev_char";
              right = "go_to_next_char";
              home = "go_to_input_start";
              ctrl-a = "go_to_input_start";
              end = "go_to_input_end";
              ctrl-e = "go_to_input_end";
            };

            events = {
              mouse-scroll-up = "scroll_preview_up";
              mouse-scroll-down = "scroll_preview_down";
            };

            shell_integration = {
              fallback_channel = "files";

              channel_triggers = {
                alias = [
                  "alias"
                  "unalias"
                ];
                env = [
                  "export"
                  "unset"
                ];
                dirs = [
                  "cd"
                  "ls"
                  "rmdir"
                  "z"
                ];
                files = [
                  "cat"
                  "less"
                  "head"
                  "tail"
                  "vim"
                  "nano"
                  "bat"
                  "cp"
                  "mv"
                  "rm"
                  "touch"
                  "chmod"
                  "chown"
                  "ln"
                  "tar"
                  "zip"
                  "unzip"
                  "gzip"
                  "gunzip"
                  "xz"
                ];
                git-diff = [
                  "git add"
                  "git restore"
                ];
                git-branch = [
                  "git checkout"
                  "git branch"
                  "git merge"
                  "git rebase"
                  "git pull"
                  "git push"
                ];
                git-log = [
                  "git log"
                  "git show"
                ];
                docker-images = [ "docker run" ];
                git-repos = [
                  "nvim"
                  "code"
                  "hx"
                  "git clone"
                ];
              };

              keybindings = {
                smart_autocomplete = "ctrl-t";
                command_history = "ctrl-r";
              };
            };
          };
        };
        nix-search-tv = {
          enable = true;
          enableTelevisionIntegration = true;
          settings = {
            indexes = [
              "nixpkgs"
              "home-manager"
              "nixos"
            ];

            experimental = {
              render_docs_indexes = {
                nvf = "https://notashelf.github.io/nvf/options.html";
              };
              options_file = {
                nixvim = "${args.nixvimOptions or ""}";
              };
            };
          };
        };
      };
    };
}
