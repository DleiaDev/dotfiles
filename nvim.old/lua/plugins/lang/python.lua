local nls = require("null-ls")

vim.api.nvim_create_user_command("PySource", function(opts)
  code = "import importlib.util as u, sys; s = u.find_spec(sys.argv[1]); print(getattr(s, 'origin', ''))"
  res = vim.trim(vim.fn.system({ "python3", "-c", code, opts.args }))
  if res == "" or res:match("%.pyi$") then
    vim.notify("No .py source for " .. opts.args)
    return
  end
  vim.cmd.edit(res)
end, { nargs = 1, desc = "Open real source of Python module" })

return {
  "nvimtools/none-ls.nvim",
  opts = {
    sources = {
      nls.builtins.diagnostics.mypy,
    },
  },
}
