return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 20,
            open_mapping = nil,
            hide_numbers = true,
            shade_terminals = true,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            float_opts = { border = "curved" },
            close_on_exit = false,
            auto_scroll = true,
        })

        -- Terminal-spezifische Keymaps
        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*",
            callback = function()
                local opts = { buffer = 0 }
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
                vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
                vim.keymap.set("n", "q", [[<cmd>close<CR>]], opts)
            end,
        })

        local Terminal = require("toggleterm.terminal").Terminal

        local function get_defaults()
            local ft = vim.bo.filetype
            local run_cmd = "echo 'No run command'"

            if ft == "rust" then
                run_cmd = "cargo run"
            elseif ft == "typescript" or ft == "html" or ft == "css" or ft == "javascript" then
                if vim.fn.glob("angular.json") ~= "" then
                    run_cmd = "ng test"
                else
                    run_cmd = "npm start"
                end
            end
            return run_cmd
        end

        --  Smart runner logic
        local runner_term = nil
        local last_run_cmd = nil

        local function smart_runner(force_ask)
            local default_run = get_defaults()

            if last_run_cmd and not force_ask then
                if runner_term then
                    runner_term:shutdown()
                end

                runner_term = Terminal:new({
                    cmd = last_run_cmd,
                    direction = "float",
                    auto_scroll = false,
                    on_open = function(term)
                        vim.cmd("stopinsert")
                        vim.cmd("normal! gg")
                        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = term.bufnr, silent = true })
                    end,
                })
                runner_term:toggle()
            else
                vim.ui.input(
                    { prompt = "Runner Command: ", default = last_run_cmd or default_run },
                    function(input)
                        if input then
                            last_run_cmd = input
                            smart_runner(false)
                        end
                    end
                )
            end
        end

        local function toggle_runner_output()
            if runner_term then
                runner_term:toggle()
                if runner_term:is_open() then
                    vim.cmd("stopinsert")
                    vim.cmd("normal! gg")
                end
            else
                print("Kein Runner aktiv.")
            end
        end

        -- Keymaps
        local k = vim.keymap.set
        local opts = { silent = true }

        -- Smart Runner
        k("n", "<leader>tr", function() smart_runner(false) end,
            vim.tbl_extend("force", opts, { desc = "Run: Start/Restart" }))
        k("n", "<leader>tR", function() smart_runner(true) end,
            vim.tbl_extend("force", opts, { desc = "Run: Config Command" }))
        k("n", "<leader>to", toggle_runner_output, vim.tbl_extend("force", opts, { desc = "Run: Output ansehen" }))

        for i = 1, 9 do
            k("n", "<leader>t" .. i, "<cmd>" .. i .. "ToggleTerm direction=float<cr>",
                vim.tbl_extend("force", opts, { desc = "Terminal " .. i .. ": Float" }))
        end

        k("n", "<leader>tt", "<cmd>1ToggleTerm direction=float<cr>",
            vim.tbl_extend("force", opts, { desc = "Terminal: Float" }))

        k("n", "<leader>tl", "<cmd>TermSelect<cr>",
            vim.tbl_extend("force", opts, { desc = "Terminal: Liste/Auswahl" }))
    end,
}
