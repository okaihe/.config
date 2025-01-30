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
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                disabled_filetypes = {
                    "dapui_watches",
                    "dapui_breakpoints",
                    "dapui_scopes",
                    "dapui_console",
                    "dapui_stacks",
                    "dap-repl",
                    "Avante",
                    "AvanteInput",
                    "NvimTree",
                },
            },
            sections = {
                lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
                lualine_b = {},
                lualine_c = {
                    {
                        "buffers",
                        show_filename_only = true,
                        show_modified_status = true,
                        mode = 2,
                        symbols = {
                            modified = " ●",
                            alternate_file = "",
                            directory = "",
                        },
                        buffers_color = {
                            active = "lualine_a_normal",
                            inactive = "lualine_b_normal",
                        },
                        separator = { right = "" },
                        right_padding = 2,
                    },
                },
                lualine_y = {},
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                    },
                    { "encoding" },
                    { "fileformat" },
                    { "filetype" },
                },
                lualine_z = {
                    { "location", separator = { right = "" }, left_padding = 2 },
                },
            },
        })
    end,
}

-- return {
--     "nvim-lualine/lualine.nvim",
--     config = function()
--         require("lualine").setup({
--             options = {
--                 icons_enabled = true,
--                 theme = "okai",
--
--                 section_separators = { left = "", right = "" },
--                 component_separators = { left = "", right = "" },
--
--                 disabled_filetypes = {
--                     statusline = { "NvimTree", "neo-tree" },
--                     winbar = {},
--                 },
--                 ignore_focus = {},
--                 always_divide_middle = true,
--                 globalstatus = false,
--                 refresh = {
--                     statusline = 10,
--                     tabline = 10,
--                     winbar = 10,
--                 },
--             },
--             sections = {
--                 lualine_a = { "mode" },
--                 lualine_b = { "branch" },
--                 lualine_c = { "diagnostics" },
--
--                 lualine_x = { "filename" },
--                 lualine_y = { "filetype" },
--                 lualine_z = { "progress" },
--             },
--             inactive_sections = {
--                 lualine_a = {},
--                 lualine_b = {},
--                 lualine_c = { "filename" },
--                 lualine_x = { "location" },
--                 lualine_y = {},
--                 lualine_z = {},
--             },
--             tabline = {},
--             winbar = {},
--             inactive_winbar = {},
--             extensions = {},
--         })
--     end,
-- }
