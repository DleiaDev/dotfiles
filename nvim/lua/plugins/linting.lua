return {
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufWritePost",
      "BufReadPost",
      "InsertLeave",
    },
    opts = {
      events = {
        "BufWritePost",
        "BufReadPost",
        "InsertLeave",
      },
      linters_by_ft = {
        lua = { "selene" },
        vue = { "eslint" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        -- vue = { "eslint_d" },
        -- javascript = { "eslint_d" },
        -- typescript = { "eslint_d" },
      },
      linters = {
        selene = {
          condition = function(ctx)
            return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        -- eslint_d = {
        --   env = {
        --     ESLINT_USE_FLAT_CONFIG = "true",
        --   },
        -- },
      },
    },
    config = function(_, opts)
      local M = {}
      local lint = require "lint"

      -- Add linters
      lint.linters_by_ft = opts.linters_by_ft

      -- Merge config for linters
      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        else
          lint.linters[name] = linter
        end
      end

      function M.debounce(ms, fn)
        local timer = vim.loop.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function M.lint()
        -- Get linters
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        -- Filter out linters that don't exist or don't match the condtion
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then
            vim.print("Linter not found: " .. name)
          end
          if type(linter) == "table" and linter.condition ~= nil then
            if type(linter.condition) ~= "function" then
              return linter.condition
            end
            return linter.condition(ctx)
          end
          return linter
        end, names)

        -- Run linters
        if #names > 0 then
          lint.try_lint(names)
        end
      end

      -- Autocmd
      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = M.debounce(100, M.lint),
      })
    end,
  },
}
