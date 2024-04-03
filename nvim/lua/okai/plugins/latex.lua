return {
    "lervag/vimtex",
    config = function()
        vim.cmd([[
            let g:tex_flavor='latex'
            let g:vimtex_view_method = 'skim'
            " let g:vimtex_latexmk_options = '-pdf -shell-escape -verbose -file-line-error -synctex=1 -interaction=nonstopmode'
            " let g:vimtex_view_skim_sync = 1
            " let g:vimtex_view_skim_activate = 1
        ]])
    end,
}
