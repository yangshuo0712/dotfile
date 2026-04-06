local P = {}

P.statusline = {
  -- Diagnostic colors (can be overridden)
  error   = "#bf616a",
  warn    = "#ebcb8b",
  hint    = "#88c0d0",
  info    = "#a3be8c",
  -- Optional overrides: set to nil to follow theme
  -- normal_bg  = "#4c566a",
  -- normal_fg  = "#dfdee9",
  normal_bg  = nil,
  normal_fg  = nil,
  fg_winbar  = nil,
}

P.theme = {}

return P
