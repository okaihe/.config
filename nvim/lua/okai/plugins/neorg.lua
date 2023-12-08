return {
	"nvim-neorg/neorg",
	run = ":Neorg sync-parsers", -- This is the important bit!
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.completion"] = {
					config = {
						engine = "nvim-cmp",
					},
				},
				["core.dirman"] = {
					config = {
						workspaces = {
							work = "~/notes/work",
							personal = "~/notes/personal",
						},
            default_workspace = "work",
					},
				},
			},
		})
	end,
}
