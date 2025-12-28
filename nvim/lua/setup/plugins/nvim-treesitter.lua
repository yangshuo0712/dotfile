return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    local languages = {
      "python", "lua", "markdown", "markdown_inline",
      "yaml", "rust", "go", "html", "vim", "vimdoc"
    }

    ts.install(languages)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function(args)
        local bufnr = args.buf

        vim.treesitter.start(bufnr)

        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldlevel = 99
      end,
    })
  end,
}
