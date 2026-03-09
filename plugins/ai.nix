{ lib, pkgs, ... }:
{
  plugins.sidekick = {
    enable = true;
    settings = {
      nes.enabled = false;
      mux.enabled = false;

      # Sidekick (by default) enables a set of CLI assistants. One of those is
      # `claude-code`, which is unfree and also frequently blocked (HTTP 403)
      # when fetched from the npm registry in a pure Nix build.
      #
      # By explicitly setting the tool list, we avoid pulling `pkgs.claude-code`
      # into the Neovim build closure unless you opt in.
      cli.tools = lib.mkDefault [ pkgs.aider-chat pkgs.copilot-cli ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<tab>";
      action.__raw = ''
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end
      '';
      options = {
        expr = true;
        desc = "Goto/Apply Next Edit Suggestion";
      };
    }
    {
      mode = "n";
      key = "<leader>aa";
      action.__raw = "function() require('sidekick.cli').toggle({ name = 'copilot' }) end";
      options.desc = "Sidekick Toggle Copilot";
    }
    {
      mode = "n";
      key = "<leader>aA";
      action.__raw = "function() require('sidekick.cli').toggle({ name = 'aider' }) end";
      options.desc = "Sidekick Toggle Aider";
    }
    {
      mode = "n";
      key = "<leader>as";
      action.__raw = "function() require('sidekick.cli').select({ filter = { installed = true } }) end";
      options.desc = "Select CLI";
    }
    {
      mode = [
        "x"
        "n"
      ];
      key = "<leader>at";
      action.__raw = "function() require('sidekick.cli').send({ msg = '{this}' }) end";
      options.desc = "Send This";
    }
    {
      mode = "x";
      key = "<leader>av";
      action.__raw = "function() require('sidekick.cli').send({ msg = '{selection}' }) end";
      options.desc = "Send Visual Selection";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>ap";
      action.__raw = "function() require('sidekick.cli').prompt() end";
      options.desc = "Sidekick Select Prompt";
    }
    {
      mode = [
        "n"
        "x"
        "i"
        "t"
      ];
      key = "<c-.>";
      action.__raw = "function() require('sidekick.cli').focus() end";
      options.desc = "Sidekick Switch Focus";
    }
  ];
}
