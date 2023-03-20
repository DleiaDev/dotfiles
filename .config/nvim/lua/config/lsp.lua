
local floatConfig = {
  focusable = true,
  style = 'minimal',
  border = 'rounded',
}

local diagnosticSigns = {
  { name = 'DiagnosticSignWarn', icon = '' },
  { name = 'DiagnosticSignHint', icon = '' },
  { name = 'DiagnosticSignInfo', icon = '' },
  { name = 'DiagnosticSignError', icon = '' },
}
for _, sign in ipairs(diagnosticSigns) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.icon, numhl = sign.name })
end

vim.diagnostic.config({
  float = vim.tbl_deep_extend('force', floatConfig, {
    format = function(diagnostic)
      local code = diagnostic.code or (diagnostic.user_data and diagnostic.user_data.lsp.code)
      return string.format('%s: %s (%s)', diagnostic.source, diagnostic.message, code)
    end
  }),
  virtual_text = {
    spacing = 4,
    prefix = '',
  },
})

-- Hanlders
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, floatConfig)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, floatConfig)

---------------- lspconfig ------------------

local augroup = vim.api.nvim_create_augroup('LspFormatting', {
  clear = true,
})

local onAttach = function(client, bufnr)

  -- Keymaps
  local defaultOpts = { noremap = true, silent = true }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, defaultOpts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, defaultOpts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, defaultOpts)
  vim.keymap.set({ 'i', 'n' }, '<M-s>', vim.lsp.buf.signature_help, defaultOpts)
  vim.keymap.set('n', '<leader>lr', '<cmd>Telescope lsp_references<cr>', defaultOpts)
  vim.keymap.set('n', '<leader>lR', vim.lsp.buf.rename, defaultOpts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, defaultOpts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, defaultOpts)
  --vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, defaultOpts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSuppot = true

vim.cmd('packadd mason.nvim')

local Masonlspconfig = require('mason-lspconfig')
Masonlspconfig.setup({
  ensure_installed = {
    'sumneko_lua',
    'volar',
    'tsserver',
    'intelephense',
    'emmet_ls',
    'jsonls',
  },
})

local Neodev = require('neodev')
Neodev.setup({})

local Lspconfig = require('lspconfig')

-- sumneko_lua
Lspconfig.sumneko_lua.setup({
  on_attach = onAttach,
  capabilities = capabilities,
})

-- volar
Lspconfig.volar.setup({
  on_attach = onAttach,
  capabilities = capabilities,
  filetypes = { 'javascript', 'typescript', 'vue' },
})

-- tsserver
Lspconfig.tsserver.setup({
  on_attach = onAttach,
  capabilities = capabilities,
})

-- intelephense
Lspconfig.intelephense.setup({
  on_attach = onAttach,
  capabilities = capabilities,
})

-- jsonls
Lspconfig.jsonls.setup({
  on_attach = onAttach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
})

-- emmet_ls
local emmetFiletypes = Lspconfig.emmet_ls.document_config.default_config.filetypes
table.insert(emmetFiletypes, 'vue')
--Lspconfig.emmet_ls.setup({
--  on_attach = onAttach,
--  capabilities = capabilities,
--  filetypes = emmetFiletypes,
--  init_options = {
--    html = {
--      options = {
--        ['bem.enabled'] = true,
--      },
--    },
--  },
--})

------------------ null-ls ---------------------

local Nullls = require('null-ls')
local MasonNullls = require('mason-null-ls')

Nullls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            filter = function(client)
              return client.name == 'null-ls'
            end,
            bufnr = bufnr
          })
        end
      })
    end
  end
})

MasonNullls.setup({
  ensure_installed = {
    'eslint_d',
    'prettierd',
  },
  automatic_installation = true,
})

MasonNullls.setup_handlers({
  eslint_d = function()
    local filetypes = { 'javascript', 'vue' }
    Nullls.register(Nullls.builtins.diagnostics.eslint_d.with({ filetypes = filetypes }))
    Nullls.register(Nullls.builtins.code_actions.eslint_d.with({ filetypes = filetypes }))
  end,
  prettierd = function()
    Nullls.register(Nullls.builtins.formatting.prettierd)
  end
})
Nullls.setup()

