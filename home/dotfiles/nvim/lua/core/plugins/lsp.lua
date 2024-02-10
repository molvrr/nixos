local servers = {
  {name = "rust_analyzer", opts = {}},
  {name = "ocamllsp", opts = {}},
  {name = "elmls", opts = {}},
  {name = "tsserver", opts = {}},
  {name = "hls", opts = {}},
  {name = "gopls", opts = {}},
  {name = "unison", opts = {}},
  -- {name = "roc", opts = {}},
  {name = "elixirls", opts = {cmd = {"elixir-ls"}}},
}

--[[
  local on_attach = function(client, bufnr)
  normal_map("gd", vim.lsp.buf.definition)
  normal_map("<F2>", vim.lsp.buf.rename)
  normal_map("[d", vim.diagnostic.goto_prev)
  normal_map("]d", vim.diagnostic.goto_next)
  normal_map("<Leader>lf", vim.lsp.buf.format)
  normal_map("<Leader>la", vim.lsp.buf.code_action)
  normal_map("K", vim.lsp.buf.hover)
end
--]]

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>d', function()
      local builtin = require('telescope.builtin')
      builtin.diagnostics()
    end)

    vim.keymap.set('n', 'gr', function()
      local builtin = require('telescope.builtin')

      builtin.lsp_references()
    end, opts)
    vim.keymap.set('n', '<space>lf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local setup_cmp = function()
  local cmp = require('cmp')
  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    view = {
      docs = {
        auto_open = true
      }
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })
end

local setup_lsp = function()
  local lspconfig = require('lspconfig')

  for _, server in ipairs(servers) do
    lspconfig[server.name].setup({})
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    config = setup_lsp,
    dependencies = {{"hrsh7th/nvim-cmp", config = setup_cmp}, {"hrsh7th/cmp-nvim-lsp"}, {"L3MON4D3/LuaSnip"}, {"saadparwaiz1/cmp_luasnip"}, {"PaterJason/cmp-conjure", enabled = false}}
  }
} 
