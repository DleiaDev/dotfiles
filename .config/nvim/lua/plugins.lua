
local bootstrapPacker = false
local packerInstallPath = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packerCompilePath = packerInstallPath .. '/plugin/packer_compiled.lua'

local isPackerInstalled = vim.fn.glob(packerInstallPath) ~= ''

-- Install packer
if not isPackerInstalled then
  print('Downloading Packer...')
  vim.fn.system('git clone https://github.com/wbthomason/packer.nvim ' .. packerInstallPath)
  vim.cmd('packadd packer.nvim')
  bootstrapPacker = true
  print('Done.')
end

local Packer = require('packer')

-- Configure packer
Packer.init({
  compile_path = packerCompilePath,
  profile = {
    enable = true,
    threshold = 0,
  },
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end
  }
})

Packer.startup(function(use)

  -- Packer
  use('wbthomason/packer.nvim')

  -- Treesitter
  use({
    'nvim-treesitter/nvim-treesitter',
    opt = true,
    event = 'VimEnter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    requires = {
      'nvim-treesitter/playground',
      'windwp/nvim-ts-autotag',
      'RRethy/nvim-treesitter-endwise',
      { 'windwp/nvim-autopairs', module = 'nvim-autopairs' },
    },
    config = function()
      require('config.treesitter')
    end
  })

  -- nvim-tree
  use({
    'nvim-tree/nvim-tree.lua',
    cmd = {
      'NvimTreeToggle',
      'NvimTreeFocus',
      'NvimTreeFindFile',
    },
    tag = 'nightly',
    requires = { 'nvim-tree/nvim-web-devicons', module = 'nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup()
    end
  })

  -- Diffview
  use({
    'sindrets/diffview.nvim',
    cmd = 'DiffviewOpen',
    requires = { 'nvim-lua/plenary.nvim', module = 'plenary' },
  })

  -- Onedark
  use({
    'navarasu/onedark.nvim',
    --event = 'VimEnter',
    config = function()
      require('config.onedark')
    end
  })

  -- Lualine
  use({
    'nvim-lualine/lualine.nvim',
    event = 'VimEnter',
    requires = {
      { 'nvim-tree/nvim-web-devicons', module = 'nvim-web-devicons' },
    },
    config = function()
      require('config.lualine')
    end
  })

  -- Telescope
  use({
    'nvim-telescope/telescope.nvim',
    keys = {
      '<leader>f',
      '<leader>F',
      '<leader>s',
      '<leader>g',
      '<leader>h',
      '<leader>b',
      '<leader>lr',
    },
    requires = {
      { 'nvim-lua/plenary.nvim', module = 'plenary' },
      { 'nvim-tree/nvim-web-devicons', module = 'nvim-web-devicons' },
      { 'nvim-telescope/telescope-fzy-native.nvim', module = 'telescope._extensions.fzy_native' },
      {
        'HendrikPetertje/telescope-media-files.nvim',
        module = 'telescope._extensions.media_files',
        branch = 'fix-replace-ueber-with-viu',
      }
    },
    config = function()
      package.loaded['config.telescope'] = nil
      require('config.telescope')
    end,
  })

  -- Mason
  use({
    'williamboman/mason.nvim',
    event = {
      'VimEnter',
      'BufReadPre',
    },
    config = function()
      require('mason').setup()
    end
  })

  -- LSP
  use({
    'williamboman/mason-lspconfig.nvim',
    event = 'BufReadPre',
    requires = {
      { 'neovim/nvim-lspconfig', module = 'lspconfig' },
      { 'jayp0521/mason-null-ls.nvim', module = 'mason-null-ls' },
      {
        'jose-elias-alvarez/null-ls.nvim',
        module = 'null-ls',
        requires = 'nvim-lua/plenary.nvim',
      },
      { 'folke/neodev.nvim', module = 'neodev' },
      { 'hrsh7th/cmp-nvim-lsp', module = 'cmp_nvim_lsp' },
      { 'b0o/SchemaStore.nvim', module = 'schemastore' },
    },
    config = function()
      require('config.lsp')
    end
  })

  -- cmp
  use({
    'hrsh7th/nvim-cmp',
    opt = true,
    event = {
      'InsertEnter',
      'CmdlineEnter',
    },
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
      {
        'L3MON4D3/LuaSnip',
        module = 'luasnip',
        requires = 'rafamadriz/friendly-snippets',
      },
      { 'onsails/lspkind.nvim', module = 'lspkind' },
    },
    config = function()
      require('config.cmp')
    end
  })

  -- kitty
  use({
    'fladson/vim-kitty',
  })

  if bootstrapPacker then
    Packer.sync()
  end

end)

