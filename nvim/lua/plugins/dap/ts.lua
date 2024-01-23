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
        sourceMaps = true,
        resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
        cwd = "${workspaceFolder}/resources",
        skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
      },
      {
        type = "pwa-chrome",
        request = "launch",
        name = "Launch a browser to debug client side code",
        url = "http://localhost",
        sourceMaps = true,
        webRoot = "${workspaceFolder}/resources",
        runtimeExecutable = "/usr/bin/brave-browser-stable",
        skipFiles = {
          "**/node_modules/**/*",
          "**/@vite/*",
        },
      },
    }
  end
end

return M
