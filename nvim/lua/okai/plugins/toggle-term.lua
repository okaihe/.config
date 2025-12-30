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

        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
            vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
            vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
            vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
            vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
            vim.keymap.set("n", "q", [[<cmd>close<CR>]], opts)
        end
        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

        local Terminal = require("toggleterm.terminal").Terminal

        local function get_defaults()
            local ft = vim.bo.filetype
            local file = vim.fn.expand("%")

            -- Defaults
            local run_cmd = "echo 'No run command'"
            local server_cmd = "echo 'No server command'"

            if ft == "rust" then
                run_cmd = "cargo run"
                server_cmd = "cargo watch -x run"
            elseif ft == "python" then
                run_cmd = "python3 " .. file
                server_cmd = "python3 -m http.server"
            elseif ft == "java" then
                run_cmd = "mvn test"
                -- Dein spezieller Java Command:
                server_cmd = "setjava 17 && readenv && mvn spring-boot:run"
            elseif ft == "typescript" or ft == "html" or ft == "css" or ft == "javascript" then
                -- Einfache Angular Erkennung
                if vim.fn.glob("angular.json") ~= "" then
                    server_cmd = "ng serve"
                    run_cmd = "ng test"
                else
                    run_cmd = "npm start"
                    server_cmd = "npm run dev"
                end
            end

            return run_cmd, server_cmd
        end

        -- RUNNER (Scripts)
        local runner_term = nil
        local last_run_cmd = nil

        local function smart_runner(force_ask)
            local default_run, _ = get_defaults()

            if last_run_cmd and not force_ask then
                if runner_term then
                    runner_term:shutdown()
                end

                runner_term = Terminal:new({
                    cmd = last_run_cmd,
                    direction = "float",
                    on_open = function(term)
                        vim.cmd("startinsert!")
                        vim.api.nvim_buf_set_keymap(
                            term.bufnr,
                            "n",
                            "q",
                            "<cmd>close<CR>",
                            { noremap = true, silent = true }
                        )
                    end,
                })
                runner_term:toggle()
            else
                vim.ui.input({ prompt = "Runner Command: ", default = last_run_cmd or default_run }, function(input)
                    if input then
                        last_run_cmd = input
                        smart_runner(false)
                    end
                end)
            end
        end

        local function toggle_runner_output()
            if runner_term then
                runner_term:toggle()
                if runner_term:is_open() then
                    vim.cmd("stopinsert")
                end
            else
                print("Kein Runner aktiv.")
            end
        end

        -- SERVER
        local server_term = nil
        local last_server_cmd = nil

        local function smart_server(force_new)
            local _, default_server = get_defaults()

            if server_term and not force_new then
                server_term:toggle()
                if server_term:is_open() then
                    vim.cmd("startinsert!")
                end
                return
            end

            vim.ui.input({ prompt = "Server Command: ", default = last_server_cmd or default_server }, function(input)
                if input then
                    last_server_cmd = input

                    if server_term then
                        server_term:shutdown()
                    end

                    server_term = Terminal:new({
                        cmd = input,
                        direction = "horizontal", -- Server unten angedockt
                        hidden = true,
                        on_open = function(term)
                            vim.cmd("startinsert!")
                            vim.api.nvim_buf_set_keymap(
                                term.bufnr,
                                "n",
                                "q",
                                "<cmd>close<CR>",
                                { noremap = true, silent = true }
                            )
                        end,
                    })
                    server_term:toggle()
                end
            end)
        end

        -- LAZYGIT
        local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = { border = "double" },
            on_open = function(term)
                vim.cmd("startinsert!")
                local opts = { buffer = term.bufnr }
                vim.keymap.del("t", "<C-h>", opts)
                vim.keymap.del("t", "<C-j>", opts)
                vim.keymap.del("t", "<C-k>", opts)
                vim.keymap.del("t", "<C-l>", opts)
                vim.keymap.del("t", "<esc>", opts)
            end,
            close_on_exit = true,
        })

        -- KEYMAPS
        local k = vim.keymap.set

        -- Runner
        k("n", "<leader>tr", function()
            smart_runner(false)
        end, { desc = "Run: Start/Restart" })
        k("n", "<leader>tR", function()
            smart_runner(true)
        end, { desc = "Run: Config Command" })
        k("n", "<leader>to", toggle_runner_output, { desc = "Run: Output ansehen" })

        -- Server
        k("n", "<leader>ts", function()
            smart_server(false)
        end, { desc = "Server: Start/Toggle" })
        k("n", "<leader>tS", function()
            smart_server(true)
        end, { desc = "Server: Config/Restart" })

        -- Git
        k("n", "<leader>gg", function()
            lazygit:toggle()
        end, { desc = "Git: LazyGit" })

        -- Global
        k("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal: Float" })
    end,
}
