{ pkgs, inputs, ... }:
{
  plugins = {
    gitsigns = {
      enable = true;
      settings = { };
    };

    # git-blame.nvim (nixvim module: gitblame)
    gitblame = {
      enable = true;
      settings = {
        enabled = true;
        message_template = "<author> • <date> <<sha>>";
        date_format = "%r";
      };
    };

    diffview = {
      enable = true;
      settings = {
        enhanced_diff_hl = true;
        use_icons = true;
        view.merge_tool = {
          layout = "diff3_horizontal";
          winbar_info = true;
          disable_diagnostics = true;
        };
      };
    };
  };

  # git-scripts.nvim and resolved.nvim – not in nixvim or nixpkgs, use flake inputs
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "git-scripts-nvim";
      src = inputs.git-scripts-nvim;
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "resolved-nvim";
      src = inputs.resolved-nvim;
    })
  ];

  extraConfigLua = ''
    -- git-scripts: auto-commit vault notes on save
    local home = vim.fn.expand("~")
    local vault_pattern = home .. "/vault/*.md"
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
      pattern = vault_pattern,
      once = true,
      callback = function()
        local ok, gitscripts = pcall(require, "git-scripts")
        if not ok then return end
        gitscripts.setup({ default_keymaps = false, commit_on_save = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
          callback = function()
            gitscripts.async_pull()
          end,
          desc = "Auto pull repo on enter",
        })
      end,
    })

    -- resolved.nvim
    pcall(function() require("resolved").setup() end)
  '';

  extraPackages = with pkgs; [
    lazygit
    git
  ];
}
