local M = {}

local palette = require 'setup.custom.utils.palette'

local function set_common_highlights(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "CustomStatusLineError",   { fg = p.error })
  hl(0, "CustomStatusLineWarning", { fg = p.warn  })
  hl(0, "CustomStatusLineHint",    { fg = p.hint,  bg = p.bg_dark })
  hl(0, "CustomStatusLineInfo",    { fg = p.info,  bg = p.bg_dark })
  hl(0, "CustomStatusLineNormal",  { fg = p.normal, bg = p.bg_line })
  hl(0, "CustomWinbar",            { fg = p.fg_winbar, bg = "NONE" })
end

local function set_theme_overrides()
  local hl = vim.api.nvim_set_hl
  local theme = vim.g.colors_name

  hl(0, "SnacksPicker",  { bg = "none", nocombine = true })
  hl(0, "WinSeparator",  { fg = "#43445E", bg = "none", nocombine = true })
  vim.cmd([[highlight! link WinBar Normal]])
  vim.cmd([[highlight! link WinBarNC Normal]])
  vim.cmd([[highlight! link TroubleNormal Normal]])
  vim.cmd([[highlight! link TroubleNormalNC Normal]])
  vim.cmd([[highlight! link LspInlayHint Comment]])

  if theme == "nord" then
    vim.cmd([[highlight! link NonText Comment]])
    vim.cmd([[highlight! MiniCursorword guifg=NONE guibg=NONE gui=underline]])
    vim.cmd([[highlight! MiniCursorwordCurrent guifg=NONE guibg=NONE gui=underline]])
    hl(0, "FloatBorder",        { fg = "#434C5E", bg = "none" })
    hl(0, "@markup.link",       { fg = "#81A1C1", bg = "none" })
    hl(0, "@markup.heading.1.markdown", { fg = "#8FBCBB", bold = true })
    hl(0, "@markup.heading.2.markdown", { fg = "#88C0D0", bold = true })
    hl(0, "@markup.heading.3.markdown", { fg = "#81A1C1", bold = true })
    hl(0, "@markup.heading.4.markdown", { fg = "#5E81AC", bold = true })
    hl(0, "@markup.heading.5.markdown", { fg = "#81ACC1", bold = true })
    hl(0, "@markup.heading.6.markdown", { fg = "#4C566A", bold = true })
  elseif theme == "onenord" then
    vim.cmd([[highlight! MiniCursorword guifg=NONE guibg=NONE gui=underline]])
    vim.cmd([[highlight! MiniCursorwordCurrent guifg=NONE guibg=NONE gui=underline]])
    hl(0, "FloatBorder",   { fg = "#81A1C1", bg = "none" })
    hl(0, "NormalFloat",   { fg = "#C8D0E0", bg = "#2e3440" })
    hl(0, "StatusLine",    { fg = "#D8DEE9", bg = "#434C5E" })
    local nord_fg = "#81A1C1"
    for _, grp in ipairs({
      "SnacksNotifierBorderInfo",
      "SnacksNotifierIconInfo",
      "SnacksNotifierTitleInfo",
      "SnacksNotifierFooterInfo",
    }) do
      hl(0, grp, { fg = nord_fg, bg = "none" })
    end
  end
end

function M.setup()
  set_common_highlights(palette)
  set_theme_overrides()
end

return M

