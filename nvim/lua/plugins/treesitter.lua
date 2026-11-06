return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
    },
    opts = {
      ensure_installed = {
        'lua', 'vim', 'vimdoc', 'bash', 'json', 'yaml', 'toml', 'markdown',
        'javascript', 'typescript', 'tsx', 'python', 'powershell', 'vue',
        'c_sharp', -- neotest test discovery
      },
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          node_decremental = 'grm',
          scope_incremental = 'grc',
        },
      },
      refactor = {
        smart_rename = { enable = true, keymaps = { smart_rename = 'grr' } },
        highlight_definitions = { enable = false },
        navigation = { enable = true },
      },
      textobjects = { select = { enable = true } },
    },
    config = function(_, opts)
      if vim.fn.has("win32") == 1 then
        local program_files_x86 = vim.env["ProgramFiles(x86)"]
        local vswhere = program_files_x86
            and vim.fs.joinpath(program_files_x86, "Microsoft Visual Studio", "Installer", "vswhere.exe")

        if vswhere and vim.fn.executable(vswhere) == 1 then
          local vs_root = vim.trim(vim.fn.systemlist({
            vswhere,
            "-latest",
            "-products",
            "*",
            "-requires",
            "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
            "-property",
            "installationPath",
          })[1] or "")
          local msvc_roots = vs_root
              and vim.fn.glob(vim.fs.joinpath(vs_root, "VC", "Tools", "MSVC", "*"), false, true)
              or {}
          table.sort(msvc_roots)
          local msvc_root = msvc_roots[#msvc_roots]
          local sdk_roots = program_files_x86
              and vim.fn.glob(vim.fs.joinpath(program_files_x86, "Windows Kits", "10", "Include", "*"), false, true)
              or {}
          table.sort(sdk_roots)
          local sdk_include = sdk_roots[#sdk_roots]

          if msvc_root and sdk_include then
            local sdk_version = vim.fs.basename(sdk_include)
            local sdk_root = vim.fs.joinpath(program_files_x86, "Windows Kits", "10")
            local compiler_dir = vim.fs.joinpath(msvc_root, "bin", "Hostx64", "x64")
            local compiler = vim.fs.joinpath(compiler_dir, "cl.exe")

            if vim.fn.executable(compiler) == 1 then
              vim.env.INCLUDE = table.concat({
                vim.fs.joinpath(msvc_root, "include"),
                vim.fs.joinpath(sdk_root, "Include", sdk_version, "ucrt"),
                vim.fs.joinpath(sdk_root, "Include", sdk_version, "shared"),
                vim.fs.joinpath(sdk_root, "Include", sdk_version, "um"),
                vim.fs.joinpath(sdk_root, "Include", sdk_version, "winrt"),
                vim.env.INCLUDE or "",
              }, ";")
              vim.env.LIB = table.concat({
                vim.fs.joinpath(msvc_root, "lib", "x64"),
                vim.fs.joinpath(sdk_root, "Lib", sdk_version, "ucrt", "x64"),
                vim.fs.joinpath(sdk_root, "Lib", sdk_version, "um", "x64"),
                vim.env.LIB or "",
              }, ";")
              vim.env.PATH = compiler_dir .. ";" .. (vim.env.PATH or "")
              local install = require("nvim-treesitter.install")
              table.insert(install.compilers, 1, compiler)
            end
          end
        end
      end

      -- Adapt the legacy branch's single-node predicates to Neovim's node lists.
      local q = vim.treesitter.query
      local add_predicate, add_directive = q.add_predicate, q.add_directive
      local function adapt(handler)
        return function(match, ...)
          local flat = {}
          for id, nodes in pairs(match) do
            flat[id] = nodes[#nodes]
          end
          return handler(flat, ...)
        end
      end
      q.add_predicate = function(name, handler, o) return add_predicate(name, adapt(handler), o) end
      q.add_directive = function(name, handler, o) return add_directive(name, adapt(handler), o) end
      package.loaded['nvim-treesitter.query_predicates'] = nil
      require('nvim-treesitter.query_predicates')
      q.add_predicate, q.add_directive = add_predicate, add_directive
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
