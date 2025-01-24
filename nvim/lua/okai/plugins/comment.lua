return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            config = function()
                require("ts_context_commentstring").setup({})
                vim.g.skip_ts_context_commentstring_module = true
            end,
        },
    },
    config = function()
        require("Comment").setup({
            pre_hook = function(ctx)
                local U = require("Comment.utils")
                if vim.bo.filetype == "angular" then
                    local type = ctx.ctype == U.ctype.line and "// %s" or "/* %s */"
                    vim.bo.commentstring = "<!-- %s -->"
                    return vim.bo.commentstring
                end
                return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
            end,
        })
    end,
}
