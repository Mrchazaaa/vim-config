-- Add the current directory to the Lua path
local config_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ':p:h')
package.path = config_path .. '/lua/?.lua;' .. config_path .. '/lua/?/init.lua;' .. package.path

-- Prefer LF line endings (matches repo .gitattributes; avoids diffview CRLF/LF mismatch)
vim.opt.fileformats = { "unix", "dos" }

-- Keep crash-recovery files out of project directories.
local swap_dir = vim.fn.stdpath("state") .. "/swap"
vim.fn.mkdir(swap_dir, "p")
vim.opt.directory = swap_dir .. "//"

-- Tree-sitter based code folding (folds start open).
-- Set per-window when a treesitter parser exists, so lazy-loaded parsers still fold.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if pcall(vim.treesitter.get_parser, args.buf) then
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt_local.foldenable = false
    end
  end,
})

-- OmniSharp spams WARN-level noise (grew lsp.log to 6.8GB). Only log real errors.
vim.lsp.log.set_level(vim.log.levels.ERROR)

-- Bootstrap lazy.nvim (this must happen before requiring lazy)
require('lazy-bootstrap')

-- Setup lazy.nvim with plugins (now lazy.nvim is available)
require('lazy').setup(require('lazy-plugins'), {
  change_detection = { notify = false },
  rocks = { enabled = false },
  performance = {
    rtp = {
      paths = { "/usr/lib/nvim" },
    },
  },
})

-- UI components (theme customizations after lazy loads)
require('ui').setup()

require('features.trim-whitespace')

vim.api.nvim_create_user_command("HelpMe", function()
  vim.cmd("tabnew " .. vim.fn.fnameescape(config_path .. "/../Help.md"))
end, { desc = "Open this configuration's help in a new tab" })

vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- Create a Lua scratchfile command
vim.api.nvim_create_user_command("LuaScratch", function()
  local scratch_path = vim.fn.stdpath("config") .. "/scratch.lua"
  vim.cmd("edit " .. scratch_path)
end, { desc = "Open Lua scratch file" })

for _, path in ipairs({
  { "AbsolutePath", ":p" },
  { "RelativePath", ":." },
  { "FileName", ":t" },
}) do
  vim.api.nvim_create_user_command("CopyBuffer" .. path[1], function()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
      vim.notify("Current buffer has no file name", vim.log.levels.WARN)
      return
    end
    local value = vim.fn.fnamemodify(name, path[2])
    vim.fn.setreg("+", value)
    vim.api.nvim_echo({ { value } }, false, {})
  end, { desc = "Copy buffer " .. path[1] .. " to clipboard" })
end

-- Copy "File.Class.member" for the symbol under the cursor (via LSP documentSymbol).
vim.api.nvim_create_user_command("CopySymbolPath", function()
  local res = vim.lsp.buf_request_sync(0, "textDocument/documentSymbol",
    { textDocument = vim.lsp.util.make_text_document_params() }, 2000)
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  line = line - 1
  local function has(r)
    return (line > r.start.line or (line == r.start.line and col >= r.start.character))
      and (line < r["end"].line or (line == r["end"].line and col <= r["end"].character))
  end
  local path = { vim.fn.expand("%:t:r") }
  for _, r in pairs(res or {}) do
    local syms = r.result
    while syms do
      local hit
      for _, s in ipairs(syms) do
        if has(s.range or s.location.range) then hit = s break end
      end
      if not hit then break end
      table.insert(path, (hit.name:gsub("%(.*", "")))
      syms = hit.children
    end
    if #path > 1 then break end
  end
  if #path == 1 then return vim.notify("No symbol at cursor", vim.log.levels.WARN) end
  local value = table.concat(path, ".")
  vim.fn.setreg("+", value)
  vim.api.nvim_echo({ { value } }, false, {})
end, { desc = "Copy File.Class.member of symbol under cursor" })
