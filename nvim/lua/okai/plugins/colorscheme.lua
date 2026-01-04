return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
        local colors = require("gruvbox").palette
        require("gruvbox").setup({
            terminal_colors = true,
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                strings = false,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            invert_intend_guides = false,
            inverse = true,
            contrast = "hard",
            palette_overrides = {},
            overrides = {
                Statement = { fg = colors.bright_aqua },
                Keyword = { fg = colors.bright_aqua },
                Conditional = { fg = colors.bright_yellow },
                LineNr = { fg = "#919191" },
            },
            transparent_mode = true,
        })
        vim.cmd([[colorscheme gruvbox]])
    end,
}
