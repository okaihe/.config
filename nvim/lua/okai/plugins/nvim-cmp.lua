return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = {
                completeopt = "menu,menuone,preview,noselect",
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "path" },
                {
                    name = "buffer",
                    option = {
                        get_bufnrs = function()
                            local bufs = {}
                            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                                local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                                if byte_size < 1024 * 1024 then
                                    table.insert(bufs, buf)
                                end
                            end
                            return bufs
                        end,
                    },
                },
            }),
            formatting = {
                format = function(entry, vim_item)
                    local icons = {
                        Text = "", Method = "󰆧", Function = "󰊕", Constructor = "",
                        Field = "󰇽", Variable = "󰂡", Class = "󰠱", Interface = "",
                        Module = "", Property = "󰜢", Unit = "", Value = "󰎠",
                        Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
                        File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "",
                        Constant = "󰏿", Struct = "", Event = "", Operator = "󰆕",
                        TypeParameter = "󰅲",
                    }
                    vim_item.kind = string.format("%s %s", icons[vim_item.kind] or "", vim_item.kind)
                    vim_item.menu = ({
                        buffer = "[Buf]",
                        nvim_lsp = "[LSP]",
                        path = "[Path]",
                    })[entry.source.name]
                    return vim_item
                end,
            },
        })
    end,
}
