local M = {}

M.filetypes = { "typescript", "javascript", "typescriptreact", "vue" }

function M.setup()
  local dap = require "dap"

  require("dap-vscode-js").setup {
    debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
  }

  for _, language in ipairs(M.filetypes) do
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach debugger to existing `node --inspect` process",
        processId = require("dap.utils").pick_process,
        resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
        skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
      },
    }
  end
end

return M
