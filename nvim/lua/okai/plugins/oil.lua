return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            columns = {
                "icon",
                "permissions",
                "size",
                "mtime",
            },
            view_options = {
                show_hidden = true,
                is_always_hidden = function(name, _)
                    return name == ".." or name == ".git" or name == ".DS_Store"
                end,
            },
            win_options = {
                wrap = false,
                signcolumn = "no",
                cursorcolumn = false,
            },
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-s>"] = "actions.select_split",
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["<C-l>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
            },
        })
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

        local function open_oil_dir_in_finder()
            local oil = require("oil")
            local dir = oil.get_current_dir()
            if dir then
                vim.fn.system({ "open", dir })
            end
        end

        vim.keymap.set("n", "<leader>of", open_oil_dir_in_finder, {
            desc = "Open Oil dir in Finder",
        })
    end,
}
