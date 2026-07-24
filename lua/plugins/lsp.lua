-- VSCode specific LSP mappings (no real LSP running in Neovim itself)

local vscode = require "vscode"

local function action(cmd)
  return function()
    vscode.action(cmd)
  end
end

-- gD / gd / gi / gy / gr — go to declaration/definition/impl/type/refs
vim.keymap.set("n", "gD", action "editor.action.revealDeclaration")
vim.keymap.set("n", "gd", action "editor.action.revealDefinition")
vim.keymap.set("n", "gi", action "editor.action.goToImplementation")
vim.keymap.set("n", "gy", action "editor.action.goToTypeDefinition")
vim.keymap.set("n", "gr", action "editor.action.goToReferences")

-- K — hover
vim.keymap.set("n", "K", action "editor.action.showHover")

-- signature help: normal + insert
vim.keymap.set("n", "<leader>ls", action "editor.action.triggerParameterHints")
vim.keymap.set("i", "<C-k>", action "editor.action.triggerParameterHints")

vim.keymap.set("n", "<leader>lr", action "editor.action.rename")

vim.keymap.set({ "n", "v" }, "<leader>la", action "editor.action.quickFix")

-- [d / ]d — diagnostic navigation (any severity)
vim.keymap.set("n", "[d", action "editor.action.marker.prevInFiles")
vim.keymap.set("n", "]d", action "editor.action.marker.nextInFiles")

-- [e / ]e — no severity-filtered command exists in VS Code's built-ins;
-- left unmapped rather than faking equivalence with [d/]d.

vim.keymap.set("n", "<leader>d", action "editor.action.showHover")

vim.keymap.set("n", "<leader>q", action "workbench.actions.view.problems")

vim.keymap.set("n", "<leader>lf", action "editor.action.formatDocument")
vim.keymap.set("x", "<leader>lf", action "editor.action.formatSelection")

-- <leader>lm — no Mason equivalent; opens Extensions view instead
vim.keymap.set("n", "<leader>lm", action "workbench.view.extensions")

return {}
