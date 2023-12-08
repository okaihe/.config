return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.indentscope").setup({
			draw = {
				delay = 100,
			},

			mappings = {
				object_scope = "ii",
				object_scope_with_border = "ai",

				-- Motions (jump to respective border line; if not present - body line)
				goto_top = "[i",
				goto_bottom = "]i",
			},

			options = {
				border = "both",
				indent_at_cursor = true,
				try_as_border = true,
			},

			-- Which character to use for drawing scope indicator
			-- symbol = "╎",
			symbol = "▏",
		})
	end,
}
