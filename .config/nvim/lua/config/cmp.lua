
local Cmp = require('cmp')
local Luasnip = require('luasnip')
local Lspkind = require('lspkind')
local CmpAutopairs = require('nvim-autopairs.completion.cmp')

vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.pumheight = 15

Cmp.setup({

  -- Snippets
  snippet = {
    expand = function(args)
      Luasnip.lsp_expand(args.body)
    end
  },

  -- Disable in comments
  --enabled = function()
  --  if vim.api.nvim_get_mode() == 'c' then
  --    return true
  --  else
  --    local CmpContext = require('cmp.config.context')
  --    return not CmpContext.in_treesitter_capture('comment') and not CmpContext.in_syntax_group('Comment')
  --  end
  --end,

  -- Keymaps
  mapping = {
    ['c-k'] = Cmp.mapping(function()
      if Cmp.visible() then
        Cmp.select_prev_item()
      elseif Luasnip.expand_or_jumpable() then
        Luasnip.expand_or_jump()
      end
    end),
    ['<c-n>'] = Cmp.mapping(Cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<c-space>'] = Cmp.mapping(Cmp.mapping.complete(), { 'i', 'c' }),
    ['<c-e>'] = Cmp.mapping(Cmp.mapping.abort(), { 'i', 'c' }),
    ['<c-y>'] = Cmp.mapping(Cmp.mapping.confirm({ select = true }), { 'i', 'c' }),
  },

  -- Sources
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },

  -- Formatting
  formatting = {
    format = Lspkind.cmp_format(),
  },

})

-- /
Cmp.setup.cmdline('/', {
  mapping = Cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

-- :
Cmp.setup.cmdline(':', {
  mapping = Cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'path' },
    { name = 'cmdline' },
  },
})

Cmp.event:on('confirm_done', CmpAutopairs.on_confirm_done())

