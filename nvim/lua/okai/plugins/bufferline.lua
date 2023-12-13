return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			separator_style = "thin",
			modified_icon = "~",
			close_icon = "",
		},
	},
	config = function()
		require("bufferline").setup({
			options = {
				offsets = {
					{
						filetype = "NvimTree",
						text = "Nvim Tree",
						separator = true,
						text_align = "left",
					},
				},
			},
		})
	end,
}
