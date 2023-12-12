return {
	"sainnhe/gruvbox-material",
	name = "gruvbox-material",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_better_performance = 1

		vim.g.gruvbox_material_disable_italic_comment = 0
		vim.g.gruvbox_material_enable_italic = 1
		vim.g.gruvbox_material_enable_bold = 1
		vim.g.gruvbox_material_transparent_background = 0

		-- Themes
		vim.g.gruvbox_material_foreground = "mix"
		vim.g.gruvbox_material_background = "hard"
		vim.g.gruvbox_material_ui_contrast = "high" -- The contrast of line numbers, indent lines, etc.
		vim.g.gruvbox_material_float_style = "dim" -- Background of floating windows

		vim.cmd.colorscheme("gruvbox-material") -- For highlights customizations go to lua/core/highlights
	end

-- 	"morhetz/gruvbox",
-- 	config = function()
--     vim.g.gruvbox_bold = 1
--     vim.g.gruvbox_italics = 1
--     vim.g.gruvbox_invert_selection = 0
--     vim.g.gruvbox_vert_split = "bg1"
--     vim.g.gruvbox_invert_signs = 0
--     vim.g.gruvbox_invert_indent_guides = 0
--     vim.g.gruvbox_invert_tabline = 0
-- 		vim.cmd.colorscheme("gruvbox")
-- 	end,
}
