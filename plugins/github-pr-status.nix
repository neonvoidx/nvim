{ lib, ... }:
{
  config.vim = {
    luaConfigRC."github-pr-status" = lib.nvim.dag.entryAnywhere /* lua */ ''
      -- ── GitHub PR/Issue status virtual text ─────────────────────────────
      --   Shows "Open" / "Merged" / "Closed" next to GitHub PR or Issue links
      --   found in the buffer. Uses the `gh` CLI when available (handles auth
      --   automatically), falls back to unauthenticated curl + GitHub API.
      --
      --   Supports:
      --     https://github.com/{owner}/{repo}/pull/{number}
      --     https://github.com/{owner}/{repo}/issues/{number}
      --
      --   For /issues/ URLs that point to a PR, the pulls endpoint is
      --   queried to detect merged status.

      local M = {}

      local state = {
        enabled     = true,
        cache_ttl   = 300,
        fail_ttl    = 30,
        debounce_ms = 500,
        max_lines   = 2000,
        prefer      = "gh",
        use_gh      = false,
        hosts       = { "github.com" },
        patterns    = nil,
        ns          = vim.api.nvim_create_namespace("github-pr-status"),
        cache       = {},
        fail        = {},
        pending     = {},
        timer       = nil,
      }

      local HLS = {
        open    = "GitHubPROpen",
        merged  = "GitHubPRMerged",
        closed  = "GitHubPRClosed",
        pending = "GitHubPRPending",
      }

      local DISPLAY = {
        open    = "Open",
        merged  = "Merged",
        closed  = "Closed",
        pending = "…",
      }

      local function ensure_highlights()
        vim.api.nvim_set_hl(0, "GitHubPROpen",    { fg = "#3fb950" })
        vim.api.nvim_set_hl(0, "GitHubPRMerged",  { fg = "#a371f7" })
        vim.api.nvim_set_hl(0, "GitHubPRClosed",  { fg = "#f85149" })
        vim.api.nvim_set_hl(0, "GitHubPRPending", { fg = "#d29922" })
      end

      local function escape_pattern(s)
        return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1"))
      end

      local function build_patterns(hosts)
        local host = table.concat(vim.tbl_map(escape_pattern, hosts), "|")
        local rel = "(" .. host .. ")/([%w_%.%-]+)/([%w_%.%-]+)/([%w_%.%-]+)/(%d+)"
        return {
          "https?://" .. rel,
          rel,
        }
      end

      local function get_cached(key)
        local e = state.cache[key]
        if e and (os.time() - e.ts) < state.cache_ttl then
          return e.status
        end
        return nil
      end

      local function format_status(num, status)
        local name = DISPLAY[status] or tostring(status)
        return { string.format(" #%s %s", num, name), HLS[status] or HLS.pending }
      end

      local function parse_pull_state(st, merged)
        if not st or st == "" then
          return nil
        end
        if st == "open" then
          return "open"
        end
        if merged and merged ~= "" then
          return "merged"
        end
        return "closed"
      end

      local function fetch_with_gh(owner, repo, kind, num, cb)
        local url = string.format("repos/%s/%s/%ss/%s", owner, repo, kind, num)
        local args = { "gh", "api", url, "--jq" }
        if kind == "pull" then
          args[#args + 1] = '.state + "|" + (.merged_at // "")'
        else
          args[#args + 1] = '.state + "|" + ((.pull_request != null) | tostring)'
        end
        local job = vim.fn.jobstart(args, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            local line = vim.trim(table.concat(data or {}, ""))
            local st, extra = line:match("^(.-)|(.*)$")
            if kind == "pull" then
              cb(parse_pull_state(st, extra))
            elseif st == "open" then
              cb("open", extra == "true")
            elseif st == "closed" then
              cb("closed", extra == "true")
            else
              cb(nil)
            end
          end,
        })
        if job <= 0 then
          cb(nil)
        end
      end

      local function fetch_with_curl(owner, repo, kind, num, cb)
        local url = string.format(
          "https://api.github.com/repos/%s/%s/%ss/%s",
          owner, repo, kind, num
        )
        local job = vim.fn.jobstart({ "curl", "-sL", url }, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            local ok, res = pcall(vim.fn.json_decode, table.concat(data or {}, ""))
            if not ok or type(res) ~= "table" then
              return cb(nil)
            end
            if kind == "pull" then
              cb(parse_pull_state(res.state, res.merged_at))
            elseif res.state == "open" then
              cb("open", type(res.pull_request) == "table")
            elseif res.state == "closed" then
              cb("closed", type(res.pull_request) == "table")
            else
              cb(nil)
            end
          end,
        })
        if job <= 0 then
          cb(nil)
        end
      end

      local function fetch_one(owner, repo, kind, num, cb)
        if state.use_gh then
          fetch_with_gh(owner, repo, kind, num, cb)
        else
          fetch_with_curl(owner, repo, kind, num, cb)
        end
      end

      local function fetch(key, cb)
        if state.pending[key] then
          return
        end
        state.pending[key] = true
        local owner, repo, kind, num = key:match("^(.-)/(.-)/(.-)/(%d+)$")
        local function done(status)
          state.pending[key] = nil
          if status then
            state.cache[key] = { status = status, ts = os.time() }
            state.fail[key] = nil
            cb(status)
          else
            state.fail[key] = os.time()
            cb(nil)
          end
        end
        if kind == "pull" then
          fetch_one(owner, repo, "pull", num, done)
        else
          fetch_one(owner, repo, "issue", num, function(status, is_pr)
            if is_pr then
              fetch_one(owner, repo, "pull", num, done)
            elseif status then
              done(status)
            else
              done(nil)
            end
          end)
        end
      end

      local function set_eol_extmark(bufnr, row, col, parts)
        pcall(vim.api.nvim_buf_set_extmark, bufnr, state.ns, row, col, {
          virt_text     = parts,
          virt_text_pos = "eol",
          hl_mode       = "combine",
        })
      end

      local function render(bufnr)
        if not state.enabled then
          return
        end
        ensure_highlights()
        if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
          return
        end
        local btype = vim.bo[bufnr].buftype
        if btype == "terminal" or btype == "quickfix" or btype == "prompt" then
          return
        end
        vim.api.nvim_buf_clear_namespace(bufnr, state.ns, 0, -1)
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        if #lines > state.max_lines then
          return
        end
        for idx, line in ipairs(lines) do
          local seen = {}
          local parts = {}
          for _, pattern in ipairs(state.patterns) do
            for _, owner, repo, kind, num in line:gmatch(pattern) do
              if kind == "pull" or kind == "issues" then
                local key = string.format("%s/%s/%s/%s", owner, repo, kind, num)
                if not seen[key] then
                  seen[key] = true
                  local status = get_cached(key)
                  if status then
                    table.insert(parts, format_status(num, status))
                  elseif not state.fail[key] then
                    table.insert(parts, format_status(num, "pending"))
                    fetch(key, function()
                      render(bufnr)
                    end)
                  end
                end
              end
            end
          end
          if #parts > 0 then
            set_eol_extmark(bufnr, idx - 1, #line, parts)
          end
        end
      end

      local function schedule_render(bufnr)
        local b = bufnr or vim.api.nvim_get_current_buf()
        if state.timer then
          state.timer:stop()
        end
        state.timer = vim.uv.new_timer()
        state.timer:start(state.debounce_ms, 0, vim.schedule_wrap(function()
          state.timer = nil
          render(b)
        end))
      end

      M.setup = function(opts)
        opts = opts or {}
        state.enabled     = opts.enabled ~= false
        state.cache_ttl   = opts.cache_ttl or 300
        state.debounce_ms = opts.debounce_ms or 500
        state.max_lines   = opts.max_lines or 2000
        state.prefer      = opts.prefer or "gh"
        state.hosts       = opts.hosts or { "github.com" }
        state.use_gh      = state.prefer == "gh" and vim.fn.executable("gh") == 1
        state.patterns    = build_patterns(state.hosts)
        ensure_highlights()

        local grp = vim.api.nvim_create_augroup("GitHubPRStatus", { clear = true })
        vim.api.nvim_create_autocmd(
          { "BufEnter", "BufWritePost", "TextChanged", "TextChangedI", "InsertLeave" },
          {
            group    = grp,
            callback = function()
              schedule_render()
            end,
          }
        )
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          group    = grp,
          callback = function()
            schedule_render()
          end,
        })
        schedule_render()
      end

      M.refresh = function()
        state.cache = {}
        state.fail = {}
        render(vim.api.nvim_get_current_buf())
      end

      M.toggle = function()
        state.enabled = not state.enabled
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          pcall(vim.api.nvim_buf_clear_namespace, b, state.ns, 0, -1)
        end
        if state.enabled then
          render(vim.api.nvim_get_current_buf())
        end
      end

      M.clear_cache = function()
        state.cache = {}
        state.fail = {}
      end

      local wk = require("which-key")
      wk.add({
        { "<leader>gp", group = "+pr-status", icon = { icon = "󰊢 " } },
      })

      vim.keymap.set("n", "<leader>gpR", function()
        M.refresh()
      end, { desc = "Refresh GitHub PR status" })

      vim.keymap.set("n", "<leader>gpt", function()
        M.toggle()
      end, { desc = "Toggle GitHub PR status" })

      vim.keymap.set("n", "<leader>gpc", function()
        M.clear_cache()
      end, { desc = "Clear GitHub PR cache" })

      M.setup({
        cache_ttl   = 300,
        prefer      = "gh",
        hosts       = { "github.com" },
      })
    '';
  };
}