return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "javascript", "typescript", "vue", "tsx" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          init_options = {
            plugins = {
              -- npm i -g @vue/typescript-plugin
              {
                name = "@vue/typescript-plugin",
                location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                languages = { "javascript", "typescript", "vue" },
              },
            },
          },
          filetypes = {
            "javascript",
            "typescript",
            "vue",
          },
        },
      },
      setup = {
        tsserver = function()
          local is_nuxt_project = false
          local file_list = vim.fn.systemlist "ls -a"
          for _, name in ipairs(file_list) do
            if name == ".nuxt" then
              is_nuxt_project = true
            end
          end
          if not is_nuxt_project then
            return
          end
          local original_definition = vim.lsp.buf.definition
          vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
            group = vim.api.nvim_create_augroup("VueGoToDefinition", { clear = true }),
            pattern = "*.vue",
            callback = function()
              vim.lsp.buf.definition = function()
                original_definition()
                vim.defer_fn(function()
                  local current_file = vim.fn.expand "%"
                  if not string.find(current_file, "components.d.ts") then
                    return
                  end
                  local line = vim.fn.getline "."
                  local path = string.match(line, '".-/(.-)"')
                  vim.cmd("edit " .. path)
                end, 100)
              end
            end,
          })
        end,
      },
    },
  },
  {
    "OlegGulevskyy/better-ts-errors.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    keys = {
      "<leader>as",
      "<leader>ax",
    },
    opts = {
      keymaps = {
        toggle = "<leader>as",
        go_to_definition = "<leader>ax",
      },
    },
  },
}
