return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		local signs = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.HINT] = "H",
			[vim.diagnostic.severity.INFO] = "I",
		}

		vim.diagnostic.config({
			virtual_text = true,
			severity_sort = true,
			float = { border = "rounded" },
			signs = {
				text = signs,
				priority = 7,
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				local map = vim.keymap.set

				map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Gehe zu Definition" }))
				map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Zeige Referenzen" }))
				map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Zeige Dokumentation" }))
				map(
					"n",
					"<leader>rn",
					vim.lsp.buf.rename,
					vim.tbl_extend("force", opts, { desc = "Variable umbenennen" })
				)
				map(
					"n",
					"<leader>ca",
					vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts, { desc = "Code Actions (Fixes)" })
				)
				map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Vorheriger Fehler" }))
				map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Nächster Fehler" }))
			end,
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		vim.lsp.config("angularls", {
			on_new_config = function(new_config, _)
				local ok, registry = pcall(require, "mason-registry")
				if not ok then
					return
				end
				if registry.has_package("vtsls") then
					local vtsls_path = registry.get_package("vtsls"):get_install_path()
					if vtsls_path then
						new_config.cmd = {
							"ngserver",
							"--stdio",
							"--tsProbeLocations",
							vtsls_path .. "/node_modules",
							"--ngProbeLocations",
							vtsls_path .. "/node_modules",
						}
					end
				end
			end,
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"vtsls",
				"angularls",
				"html",
				"cssls",
				"lua_ls",
			},
			automatic_enable = true,
		})
	end,
}
