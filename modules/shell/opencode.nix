{ den, ... }:
{
  den.aspects.opencode.homeManager =
    { ... }:
    {
      programs = {
        opencode = {
          enable = true;
          enableMcpIntegration = true;

          commands = ../../assets/ai/commands;
          skills = ../../assets/ai/skills;

          settings = {
            default_agent = "build";
            model = "oca/oca/gpt-5.4";
            small_model = "oca/oca/gpt-5.4-nano";
            enabled_providers = [ "oca" ];

            permission = {
              external_directory = "ask";
              bash = {
                "git commit*" = "ask";
                "git pull*" = "ask";
                "git merge*" = "ask";
                "git push*" = "ask";
                "git reset*" = "ask";
                "git clean*" = "ask";
                "git branch -D*" = "ask";
                "git checkout --*" = "ask";
                "git restore*" = "ask";
                "git rebase*" = "ask";
                "git commit --amend*" = "ask";
              };
            };

            tools.websearch = true;
            share = "disabled";

            provider.oca = {
              npm = "@ai-sdk/openai";
              name = "Oracle Code Assist";
              options = {
                baseURL = "https://code-internal.aiservice.us-chicago-1.oci.oraclecloud.com/20250206/app/litellm";
                headers = {
                  client = "opencode";
                  "client-version" = "0";
                };
              };
              models = {
                "oca/gpt-4.1" = {
                  name = "OpenAI GPT 4.1";
                  family = "openai";
                  attachment = true;
                  reasoning = false;
                  tool_call = true;
                  temperature = true;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 1047576;
                    output = 32768;
                  };
                  cost = {
                    input = 2;
                    output = 8;
                    cache_read = 0.5;
                  };
                  provider = {
                    npm = "@ai-sdk/openai-compatible";
                    api = "oca/gpt-4.1";
                  };
                };

                "oca/gpt-5" = {
                  name = "OpenAI GPT 5";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 272000;
                    output = 128000;
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5";
                  };
                };

                "oca/gpt-5-codex" = {
                  name = "OpenAI GPT 5 codex";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 272000;
                    output = 128000;
                  };
                  cost = {
                    input = 1.25;
                    output = 10;
                    cache_read = 0.125;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5-codex";
                  };
                };

                "oca/gpt-5-mini" = {
                  name = "OpenAI GPT 5 Mini";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 272000;
                    output = 128000;
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5-mini";
                  };
                };

                "oca/gpt-5.1" = {
                  name = "OpenAI GPT 5.1";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 272000;
                    output = 128000;
                  };
                  cost = {
                    input = 1.25;
                    output = 10;
                    cache_read = 0.13;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai-compatible";
                    api = "oca/gpt-5.1";
                  };
                };

                "oca/gpt-5.1-codex" = {
                  name = "OpenAI GPT 5.1 Codex";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 272000;
                    output = 128000;
                  };
                  cost = {
                    input = 1.25;
                    output = 10;
                    cache_read = 0.125;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5.1-codex";
                  };
                };

                "oca/gpt-5.1-codex-max" = {
                  name = "OpenAI GPT 5.1 Codex Max";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 272000;
                    output = 128000;
                  };
                  cost = {
                    input = 1.25;
                    output = 10;
                    cache_read = 0.125;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5.1-codex-max";
                  };
                };

                "oca/gpt-5.1-codex-mini" = {
                  name = "OpenAI GPT 5.1 Codex Mini";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 272000;
                    output = 128000;
                  };
                  cost = {
                    input = 0.25;
                    output = 2;
                    cache_read = 0.025;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5.1-codex-mini";
                  };
                };

                "oca/gpt-5.2" = {
                  name = "OpenAI GPT 5.2";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 272000;
                    output = 128000;
                  };
                  cost = {
                    input = 1.75;
                    output = 14;
                    cache_read = 0.175;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5.2";
                  };
                };

                "oca/gpt-5.2-codex" = {
                  name = "OpenAI GPT 5.2 Codex";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 272000;
                    output = 128000;
                  };
                  cost = {
                    input = 1.75;
                    output = 14;
                    cache_read = 0.175;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5.2-codex";
                  };
                };

                "oca/gpt-5.3-codex" = {
                  name = "OpenAI GPT 5.3 Codex";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 272000;
                    output = 128000;
                  };
                  cost = {
                    input = 1.75;
                    output = 14;
                    cache_read = 0.175;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5.3-codex";
                  };
                };

                "oca/gpt-5.4" = {
                  name = "OpenAI GPT 5.4";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 922000;
                    output = 128000;
                  };
                  cost = {
                    input = 2.5;
                    output = 15;
                    cache_read = 0.25;
                    context_over_200k = {
                      input = 5;
                      output = 22.5;
                      cache_read = 0.5;
                    };
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                    xhigh = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5.4";
                  };
                };

                "oca/gpt-5.4-mini" = {
                  name = "OpenAI GPT 5.4 Mini";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 400000;
                    output = 128000;
                  };
                  cost = {
                    input = 0.75;
                    output = 4.5;
                    cache_read = 0.075;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5.4-mini";
                  };
                };

                "oca/gpt-5.4-nano" = {
                  name = "OpenAI GPT 5.4 Nano";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 400000;
                    output = 128000;
                  };
                  cost = {
                    input = 0.2;
                    output = 1.25;
                    cache_read = 0.02;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5.4-nano";
                  };
                };

                "oca/gpt-5.4-pro" = {
                  name = "OpenAI GPT 5.4 Pro";
                  family = "openai";
                  attachment = true;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 922000;
                    output = 128000;
                  };
                  cost = {
                    input = 30;
                    output = 180;
                    context_over_200k = {
                      input = 60;
                      output = 270;
                    };
                  };
                  variants = {
                    medium = { };
                    high = { };
                    xhigh = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai";
                    api = "oca/gpt-5.4-pro";
                  };
                };

                "oca/gpt-oss-120b" = {
                  name = "OpenAI GPT OSS 120b hosted by Oracle Code Assist";
                  family = "openai";
                  attachment = false;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [ "text" ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 131072;
                    output = 20000;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai-compatible";
                    api = "oca/gpt-oss-120b";
                  };
                };

                "oca/grok-code-fast-1" = {
                  name = "Grok Code Fast 1";
                  family = "grok";
                  attachment = false;
                  reasoning = false;
                  tool_call = true;
                  temperature = true;
                  modalities = {
                    input = [ "text" ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 256000;
                    output = 10000;
                  };
                  cost = {
                    input = 0.2;
                    output = 1.5;
                    cache_read = 0.02;
                  };
                  provider = {
                    npm = "@ai-sdk/openai-compatible";
                    api = "oca/grok-code-fast-1";
                  };
                };

                "oca/grok3" = {
                  name = "Grok 3";
                  family = "grok";
                  attachment = false;
                  reasoning = false;
                  tool_call = true;
                  temperature = true;
                  modalities = {
                    input = [ "text" ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 131072;
                    output = 16000;
                  };
                  cost = {
                    input = 3;
                    output = 15;
                    cache_read = 0.75;
                  };
                  provider = {
                    npm = "@ai-sdk/openai-compatible";
                    api = "oca/grok3";
                  };
                };

                "oca/grok4" = {
                  name = "Grok 4";
                  family = "grok";
                  attachment = true;
                  reasoning = false;
                  tool_call = true;
                  temperature = true;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 128000;
                    output = 0;
                  };
                  cost = {
                    input = 3;
                    output = 15;
                    cache_read = 0.75;
                  };
                  provider = {
                    npm = "@ai-sdk/openai-compatible";
                    api = "oca/grok4";
                  };
                };

                "oca/grok4-1-fast-reasoning" = {
                  name = "Grok 4.1 Fast Reasoning";
                  family = "grok";
                  attachment = true;
                  reasoning = false;
                  tool_call = true;
                  temperature = true;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 2000000;
                    output = 500000;
                  };
                  provider = {
                    npm = "@ai-sdk/openai-compatible";
                    api = "oca/grok4-1-fast-reasoning";
                  };
                };

                "oca/grok4-20-reasoning" = {
                  name = "Grok 4.20 Reasoning";
                  family = "grok";
                  attachment = true;
                  reasoning = false;
                  tool_call = true;
                  temperature = true;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 2000000;
                    output = 500000;
                  };
                  provider = {
                    npm = "@ai-sdk/openai-compatible";
                    api = "oca/grok4-20-reasoning";
                  };
                };

                "oca/grok4-fast-reasoning" = {
                  name = "Grok 4 Fast Reasoning";
                  family = "grok";
                  attachment = true;
                  reasoning = false;
                  tool_call = true;
                  temperature = true;
                  modalities = {
                    input = [
                      "text"
                      "image"
                    ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 2000000;
                    output = 500000;
                  };
                  cost = {
                    input = 0.2;
                    output = 0.5;
                    cache_read = 0.05;
                  };
                  provider = {
                    npm = "@ai-sdk/openai-compatible";
                    api = "oca/grok4-fast-reasoning";
                  };
                };

                "oca/llama4" = {
                  name = "Llama4 hosted by Oracle Code Assist";
                  family = "llama";
                  attachment = false;
                  reasoning = false;
                  tool_call = true;
                  temperature = true;
                  modalities = {
                    input = [ "text" ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 524288;
                    output = 50000;
                  };
                  cost = {
                    input = 0.2;
                    output = 0.78;
                  };
                  provider = {
                    npm = "@ai-sdk/openai-compatible";
                    api = "oca/llama4";
                  };
                };

                "oca/openai-o3" = {
                  name = "OpenAI O3";
                  family = "openai";
                  attachment = false;
                  reasoning = true;
                  tool_call = true;
                  temperature = false;
                  modalities = {
                    input = [ "text" ];
                    output = [ "text" ];
                  };
                  limit = {
                    context = 200000;
                    output = 100000;
                  };
                  cost = {
                    input = 2;
                    output = 8;
                    cache_read = 0.5;
                  };
                  variants = {
                    low = { };
                    medium = { };
                    high = { };
                  };
                  provider = {
                    npm = "@ai-sdk/openai-compatible";
                    api = "oca/openai-o3";
                  };
                };
              };
            };
          };
          tui = {
            scroll_speed = 3;
            scroll_acceleration = {
              enabled = true;
            };
            diff_style = "auto";
          };
        };

        mcp = {
          enable = true;
          servers = {
            mcp-nixos = {
              command = "nix";
              args = [
                "run"
                "github:utensils/mcp-nixos"
                "--"
              ];
            };
            nix-agent = {
              command = "nix";
              args = [
                "run"
                "github:JEFF7712/nix-agent"
              ];
            };
          };
        };

      };
    };
}
