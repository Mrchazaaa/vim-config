local function git_root()
  local root = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })[1]

  if vim.v.shell_error ~= 0 or not root or root == "" then
    vim.notify("Not inside a Git repository", vim.log.levels.WARN)
    return nil
  end

  return root
end

local function current_git_path(root)
  local name = vim.api.nvim_buf_get_name(0)

  if name:match("^diffview://") then
    return name:match("/LOCAL/(.+)$")
      or name:match("/:%d+:/(.+)$")
      or name:match("/%x%x%x%x%x%x%x%x%x%x%x/(.+)$")
  end

  local absolute = vim.fn.fnamemodify(name, ":p")
  local prefix = vim.fn.fnamemodify(root, ":p")

  if absolute:sub(1, #prefix) == prefix then
    return absolute:sub(#prefix + 1)
  end

  return nil
end

local function open_git_word_diff(path)
  local root = git_root()
  if not root then return end

  path = path and path ~= "" and path or current_git_path(root)

  if not path or path == "" then
    vim.notify("Could not determine file path for Git word diff", vim.log.levels.WARN)
    return
  end

  vim.cmd("botright split")
  vim.cmd("resize 18")

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, bufnr)

  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].filetype = "git"
  vim.bo[bufnr].modifiable = false
  vim.wo.wrap = true
  vim.wo.number = false
  vim.wo.relativenumber = false

  local term_chan = vim.api.nvim_open_term(bufnr, {})
  local cmd = {
    "git",
    "--no-pager",
    "diff",
    "HEAD",
    "--color=always",
    "--word-diff=color",
    "--word-diff-regex=[^[:space:]]+",
    "--",
    path,
  }

  vim.fn.jobstart(cmd, {
    cwd = root,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_chan_send(term_chan, table.concat(data, "\r\n"))
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_chan_send(term_chan, table.concat(data, "\r\n"))
      end
    end,
  })
end

return {
  -- Inline git signs + hunk actions
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
    config = function()
      vim.opt.signcolumn = "yes"
    end,
  },

  -- Full git porcelain commands
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gsplit", "Gread", "Gwrite", "Gdiffsplit", "Gvdiffsplit", "Ggrep", "Gclog", "GBrowse" },
    init = function()
      -- Open :Git status in a new tab by default (nice for larger views)
      vim.g.fugitive_dynamic_colors = 1
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
    init = function()
      vim.opt.diffopt = {
        "internal",
        "filler",
        "closeoff",
        "hiddenoff",
        "algorithm:histogram",
        "linematch:60",
      }

      vim.api.nvim_create_user_command("GitWordDiff", function(opts)
        open_git_word_diff(opts.args)
      end, {
        nargs = "?",
        complete = "file",
        desc = "Open a Git word diff for the current file",
      })
    end,
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = true,
      use_icons = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      default_args = {
        DiffviewOpen = { "--unfold-all" },
      },
      hooks = {
        diff_buf_win_enter = function()
          vim.keymap.set("n", "<leader>wd", function()
            open_git_word_diff()
          end, { buffer = true, desc = "Open Git word diff" })
        end,
      },
    },
  },
}
