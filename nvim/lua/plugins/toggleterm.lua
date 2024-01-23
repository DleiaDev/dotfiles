return {
  "akinsho/toggleterm.nvim",
  keys = {
    "<C-\\>",
    { "<leader>ts", "<cmd>TermSelect<cr>", desc = "TermSelect" },
  },
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    open_mapping = "<C-\\>",
    shade_terminals = false,
    shading_factor = 0.3,
    direction = "float",
    autochdir = true,
  },
}
