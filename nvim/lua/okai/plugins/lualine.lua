return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status")

        lualine.setup({
            options = {
                theme = "auto",
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                globalstatus = true,
            },
            sections = {
                lualine_a = {
                    {
                        "mode",
                        icon = "",
                        padding = { left = 1, right = 1 },
                    },
                },
                lualine_b = {
                    { "branch", icon = "" },
                    { "diff", symbols = { added = " ", modified = " ", removed = " " } },
                },
                lualine_c = {
                    {
                        "filename",
                        path = 1,
                        symbols = {
                            modified = " ●",
                            readonly = " ",
                            unnamed = "[No Name]",
                        },
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = { error = " ", warn = " ", info = " ", hint = " " },
                    },
                },
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = "#ff9e64" },
                    },
                    { "encoding" },
                    {
                        "fileformat",
                        padding = { left = 1, right = 2 },
                    },
                    { "filetype" },
                },
                lualine_y = { "progress" },
                lualine_z = {
                    { "location", icon = "" },
                },
            },
        })
    end,
}
