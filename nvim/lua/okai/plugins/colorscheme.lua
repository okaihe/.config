return {
    "okaihe/okai",
    lazy = false,
    priority = 1000,
    config = function()
        require("okai").setup({})
        vim.cmd([[colorscheme okai]])
    end,
}
