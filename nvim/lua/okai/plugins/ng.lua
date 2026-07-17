return {
	"joeveiga/ng.nvim",
	dependencies = { "neovim/nvim-lspconfig" },
	config = function()
		local ng = require("ng")
		local opts = { noremap = true, silent = true }
		vim.keymap.set(
			"n",
			"<leader>at",
			ng.goto_template_for_component,
			vim.tbl_extend("force", opts, { desc = "Angular: Zu Template springen" })
		)
		vim.keymap.set(
			"n",
			"<leader>ac",
			ng.goto_component_with_template_file,
			vim.tbl_extend("force", opts, { desc = "Angular: Zu Komponente springen" })
		)
		vim.keymap.set(
			"n",
			"<leader>aT",
			ng.get_template_tcb,
			vim.tbl_extend("force", opts, { desc = "Angular: Typecheck-Block anzeigen" })
		)
	end,
}
