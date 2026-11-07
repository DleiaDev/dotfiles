return {
  "garymjr/nvim-snippets",
  opts = function(_, opts)
    if opts.search_paths == nil then
      opts.search_paths = {}
    end
    table.insert(opts.search_paths, vim.fn.stdpath("data") .. "/lazy/vscode-vitest-snippets")
    table.insert(opts.search_paths, vim.fn.stdpath("data") .. "/lazy/vscode-testing-library-snippets")
  end,
  dependencies = {
    "deinsoftware/vscode-vitest-snippets",
    "deinsoftware/vscode-testing-library-snippets",
  },
}
