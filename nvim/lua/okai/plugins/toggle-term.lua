return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        local toggleterm = require("toggleterm")

        toggleterm.setup({
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

        -- Runner (Python, Rust, single scripts)
        local runner_term = nil
        local last_run_cmd = nil

        local function execute_run(cmd)
            last_run_cmd = cmd
            if runner_term then
                runner_term:shutdown()
            end

            runner_term = Terminal:new({
                cmd = cmd,
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
        end

        local function smart_runner(force_ask)
            local ft = vim.bo.filetype
            local file = vim.fn.expand("%")
            local default = "echo 'No default'"

            if ft == "rust" then
                default = "cargo run"
            elseif ft == "python" then
                default = "python3 " .. file
            elseif ft == "javascript" then
                default = "npm start"
            end

            if last_run_cmd and not force_ask then
                execute_run(last_run_cmd)
            else
                vim.ui.input({ prompt = "Command: ", default = last_run_cmd or default }, function(input)
                    if input then
                        execute_run(input)
                    end
                end)
            end
        end

        -- Toggle Output (Nur ansehen, nicht neu starten)
        local function toggle_last_output()
            if runner_term then
                runner_term:toggle()
                -- TRICK: Wenn das Fenster aufgeht, erzwingen wir Normal Mode zum Scrollen!
                if runner_term:is_open() then
                    vim.cmd("stopinsert")
                end
            else
                print("Kein aktiver Runner!")
            end
        end

        -- Server (Angular, Java etc.)
        -- Java Spring Boot
        local java_term = Terminal:new({
            cmd = "setjava 17 && readenv && mvn spring-boot:run",
            direction = "horizontal",
            hidden = true,
            on_open = function(term)
                vim.cmd("startinsert!")
            end,
        })

        -- Angular Serve
        local ng_term = Terminal:new({
            cmd = "ng serve",
            direction = "horizontal",
            hidden = true,
            on_open = function(term)
                vim.cmd("startinsert!")
            end,
        })

        local function toggle_server(term_instance)
            term_instance:toggle()
        end

        local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = {
                border = "double",
            },
            on_open = function(term)
                vim.cmd("startinsert!")
                vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<C-h>")
                vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<C-j>")
                vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<C-k>")
                vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<C-l>")
            end,
            close_on_exit = true,
        })

        local function _lazygit_toggle()
            lazygit:toggle()
        end

        -- KEYMAPS
        local k = vim.keymap.set

        -- Runner Mappings
        k("n", "<leader>tr", function()
            smart_runner(false)
        end, { desc = "Run: Start/Restart" })
        k("n", "<leader>tR", function()
            smart_runner(true)
        end, { desc = "Run: Set Command" })
        k("n", "<leader>to", toggle_last_output, { desc = "Run: Show Output (Normal Mode)" })

        -- LazyGit Shortcut
        k("n", "<leader>gg", _lazygit_toggle, { desc = "Git: LazyGit" })

        -- Server Mappings (Separate Instanzen!)
        k("n", "<leader>tj", function()
            toggle_server(java_term)
        end, { desc = "Server: Java Spring" })
        k("n", "<leader>ta", function()
            toggle_server(ng_term)
        end, { desc = "Server: Angular" })

        -- Globales Terminal
        k("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal: Float" })
    end,
}
