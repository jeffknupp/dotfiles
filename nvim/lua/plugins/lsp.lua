--
-- LSP, completion, formatting.
--
-- No mason here on purpose: the servers are installed by
-- dotfiles/vim/install-lsp.sh using the package managers you already run
-- (brew, uv, go, rustup, pnpm), so nvim uses the same binaries your shell
-- does and there is no second copy to keep updated.
--
-- Servers wired up: pyright + ruff (python), gopls, rust_analyzer,
-- tsc (TypeScript 7 native, js/ts), lua_ls.
--
return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      -- tsc: TypeScript 7's native compiler has the language server built in
      -- (`tsc --lsp --stdio`). nvim-lspconfig picks a project's own
      -- node_modules/.bin/tsc if it is 7.0+, else the one on PATH (brew).
      -- This replaces ts_ls/typescript-language-server, which wraps the old
      -- JS tsserver.js that TypeScript 7 no longer ships.
      local servers = { 'pyright', 'ruff', 'gopls', 'rust_analyzer', 'tsc', 'lua_ls' }

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Per-server tweaks on top of nvim-lspconfig's defaults.
      local settings = {
        pyright = {
          -- ruff owns linting and import sorting; pyright owns types.
          -- Without this you get every diagnostic twice.
          settings = {
            pyright = { disableOrganizeImports = true },
            python = { analysis = { typeCheckingMode = 'basic' } },
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true, shadow = true },
              staticcheck = true,
            },
          },
        },
        ruff = {
          capabilities = { general = { positionEncodings = { 'utf-16' } } },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      }

      if vim.lsp.config then
        -- Neovim 0.11+ native API. nvim-lspconfig ships the cmd/root markers.
        vim.lsp.config('*', { capabilities = capabilities })
        for _, name in ipairs(servers) do
          if settings[name] then vim.lsp.config(name, settings[name]) end
        end
        vim.lsp.enable(servers)
      else
        local lspconfig = require('lspconfig')
        for _, name in ipairs(servers) do
          local cfg = vim.tbl_deep_extend('force', { capabilities = capabilities }, settings[name] or {})
          lspconfig[name].setup(cfg)
        end
      end

      -- Buffer-local mappings, set only once a server actually attaches.
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local function map(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map('gd', vim.lsp.buf.definition,      'Go to definition')
          map('gD', vim.lsp.buf.declaration,     'Go to declaration')
          map('gi', vim.lsp.buf.implementation,  'Go to implementation')
          map('gy', vim.lsp.buf.type_definition, 'Go to type definition')
          map('gr', vim.lsp.buf.references,      'References')
          map('K',  vim.lsp.buf.hover,           'Hover docs')
          map('<leader>rn', vim.lsp.buf.rename,  'Rename symbol')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
        end,
      })
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>']     = cmp.mapping.abort(),
          ['<C-b>']     = cmp.mapping.scroll_docs(-4),
          ['<C-f>']     = cmp.mapping.scroll_docs(4),
          -- Enter confirms only an explicitly selected item, so a stray <CR>
          -- still inserts a newline. This matches the pumvisible() mapping
          -- you had in your vimrc.
          ['<CR>']      = cmp.mapping.confirm({ select = false }),
          ['<Tab>']     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { 'i', 's' }),
          ['<S-Tab>']   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources(
          { { name = 'nvim_lsp' }, { name = 'luasnip' } },
          { { name = 'buffer' }, { name = 'path' } }
        ),
      })
    end,
  },

  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    opts = {
      formatters_by_ft = {
        python     = { 'ruff_organize_imports', 'ruff_format' },
        go         = { 'goimports', 'gofmt' },
        rust       = { 'rustfmt' },
        lua        = { 'stylua' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        json       = { 'prettier' },
        yaml       = { 'prettier' },
        markdown   = { 'prettier' },
      },
      -- Format on save, but never block the write: if a formatter is missing
      -- or slow, the file still saves.
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 1000, lsp_format = 'fallback' }
      end,
    },
    init = function()
      -- :FormatToggle      turn format-on-save off for this buffer
      -- :FormatToggle!     turn it off globally
      vim.api.nvim_create_user_command('FormatToggle', function(args)
        if args.bang then
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify('format on save (global): ' .. (vim.g.disable_autoformat and 'off' or 'on'))
        else
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          vim.notify('format on save (buffer): ' .. (vim.b.disable_autoformat and 'off' or 'on'))
        end
      end, { bang = true, desc = 'Toggle format on save' })
    end,
  },
}
