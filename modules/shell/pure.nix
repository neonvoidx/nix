{ den, ... }:
{
  den.aspects.pure = {
    homeManager =
      {
        config,
        pkgs,
        ...
      }:
      let
        c = config.lib.stylix.colors;
      in
      {
        home.packages = [ pkgs.pure-prompt ];

        programs.zsh = {
          sessionVariables = {
            PURE_CMD_MAX_EXEC_TIME = "0";
            PURE_GIT_DOWN_ARROW = "";
            PURE_GIT_UP_ARROW = "";
            PURE_SUSPENDED_JOBS_SYMBOL = "󰒲";
            PURE_PROMPT_VICMD_SYMBOL = "";
            PURE_PROMPT_SYMBOL = "❯";
          };

          initContent = /* bash */ ''
            autoload -Uz promptinit
            promptinit
            prompt pure

            zstyle ':prompt:pure:git:stash' show no
            zstyle ':prompt:pure:environment:node_version' show yes
            zstyle ':prompt:pure:git:dirty' detailed no
            zstyle ':prompt:pure:path:separator' dim yes

            zstyle ':prompt:pure:git:arrow' color "${c.base0C}"
            zstyle ':prompt:pure:git:branch' color "${c.base0C}"
            zstyle ':prompt:pure:path' color "${c.base0D}"
            zstyle ':prompt:pure:prompt:error' color "${c.base08}"
            zstyle ':prompt:pure:prompt:success' color "${c.base0B}"
            zstyle ':prompt:pure:prompt:continuation' color "${c.base09}"
            zstyle ':prompt:pure:suspended_jobs' color "${c.base08}"
            zstyle ':prompt:pure:user' color "${c.base0F}"
            zstyle ':prompt:pure:user:root' color "${c.base08}"

            if [[ -n $AI_AGENT$CLAUDECODE$CURSOR_AGENT$GEMINI_CLI$OPENCODE ]]; then
            	zstyle :prompt:pure:git show no
            fi
          '';
        };
      };
  };
}
