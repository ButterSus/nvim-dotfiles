-- VSCode specific git mappings

local vscode = require "vscode"

local function action(cmd, args)
  return function()
    vscode.action(cmd, { args = args })
  end
end

-- ]g / [g — next/prev git change (hunk navigation)
vim.keymap.set({ "n", "x", "o" }, "]g", action "workbench.action.editor.nextChange", { desc = "Next Git Hunk" })
vim.keymap.set({ "n", "x", "o" }, "[g", action "workbench.action.editor.previousChange", { desc = "Previous Git Hunk" })

-- <leader>gs / <leader>gr — stage / reset (revert) hunk
vim.keymap.set({ "n", "v" }, "<leader>gs", action "git.stageSelectedRanges", { desc = "Stage Hunk / Selection" })
vim.keymap.set({ "n", "v" }, "<leader>gr", action "git.revertSelectedRanges", { desc = "Reset Hunk / Selection" })

-- <leader>gp — preview hunk inline (diff popup)
vim.keymap.set("n", "<leader>gp", action "editor.action.dirtydiff.next", { desc = "Preview Hunk Inline" })

-- <leader>gb — full blame popup (GitLens-style; built-in has line blame via toggle, see below)
-- VS Code's own Git extension doesn't have a "full blame popup" command;
-- closest built-in equivalent is enabling inline blame (see <leader>gt).
-- If you install GitLens, map this to "gitlens.toggleFileBlame" instead.
vim.keymap.set("n", "<leader>gb", action "git.timeline.openDiff", { desc = "Blame / Timeline" })

-- <leader>gd — diff hunk against index (open changes diff view)
vim.keymap.set("n", "<leader>gd", action "git.openChange", { desc = "Diff Against Index" })

-- <leader>gS / <leader>gR — stage / reset entire buffer (file-level)
vim.keymap.set("n", "<leader>gS", action "git.stage", { desc = "Stage Entire Buffer" })
vim.keymap.set("n", "<leader>gR", action "git.unstage", { desc = "Reset Entire Buffer" })

-- <leader>gt — toggle line blame (built-in inline blame annotations)
vim.keymap.set("n", "<leader>gt", action "git.blame.toggleEditorDecoration", { desc = "Toggle Line Blame" })

-- <leader>gq — no true built-in equivalent to "send hunks to quickfix";
-- closest is opening the Source Control view, which lists all changes
vim.keymap.set("n", "<leader>gq", action "workbench.view.scm", { desc = "Source Control (All Changes)" })

-- ig / ag — no VS Code equivalent to a hunk text object; left unmapped

-- <leader>gg — Neogit equivalent: open Source Control view
vim.keymap.set("n", "<leader>gg", action "workbench.view.scm", { desc = "Source Control" })

return {}
