return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	config = function()
		require("dressing").setup({
			select = {
				telescope = {
					previewer = true,
					borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
					layout_strategy = "vertical",
					layout_config = {
						height = 0.6,
					},
					sorting_strategy = "ascending",
				},
			},
		})
	end,
}
