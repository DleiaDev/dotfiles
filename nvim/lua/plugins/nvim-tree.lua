return {
  "nvim-tree/nvim-tree.lua",
  keys = {
    { "<leader>et", "<cmd>NvimTreeToggle<cr>", desc = "NvimTreeToggle" },
    { "<leader>er", "<cmd>NvimTreeRefresh<cr>", desc = "NvimTreeRefresh" },
    { "<leader>ef", "<cmd>NvimTreeFindFile<cr>", desc = "NvimTreeFindFile" },
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = true,
  opts = {
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    disable_netrw = true,
    hijack_netrw = true,
    view = {
      number = true,
      relativenumber = true,
    },
  },
}
