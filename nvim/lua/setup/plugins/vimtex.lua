return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        if vim.fn.has("macunix") == 1 then
            vim.g.vimtex_view_method = "skim"
        else
            vim.g.vimtex_view_method = "zathura"
        end

        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_latexmk = {
            build_dir = "",
            callback = 1,
            continuous = 1,
            executable = "latexmk",
            hooks = {},
            options = {
                "-verbose",
                "-file-line-error",
                "-synctex=1",
                "-interaction=nonstopmode",
            },
        }
    end,
}
