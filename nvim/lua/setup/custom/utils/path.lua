local M = {}

local function abbreviate(seg)
  if #seg <= 1 then
    return seg                              -- ".", "/", empty
  elseif seg:sub(1, 1) == "." then
    return "." .. seg:sub(2, 2)             -- ".config" -> ".c"
  else
    return seg:sub(1, 1)
  end
end

---@param opts? { max_depth?:integer, sep?:string, cwd_indicator?:string }
function M.pretty_path(opts)
  opts = opts or {}
  local max_depth     = opts.max_depth     or 3
  local sep           = opts.sep           or "/"
  local cwd_indicator = opts.cwd_indicator or "↯ "

  local filepath = vim.fn.expand("%:p")
  if filepath == "" then return "[No Name]" end

  local cwd     = vim.fn.getcwd()
  local in_cwd  = filepath:sub(1, #cwd) == cwd
  local relpath = in_cwd and vim.fn.fnamemodify(filepath, ":.") or filepath

  local parts = vim.split(relpath, "[/\\]")
  local len   = #parts

  if len > max_depth then
    for i = 1, len - max_depth do
      parts[i] = abbreviate(parts[i])
    end
  end

local filename = parts[#parts]
  local basename, ext = filename:match("^(.*)(%.[^.]+)$")
  if not basename then basename, ext = filename, "" end
  parts[#parts] = table.concat({
    "%#StatusLineFilename#" .. basename .. "%*",
    "%#StatusLineFileExt#"  .. ext      .. "%*",
  })

  local final = table.concat(parts, sep)
  if not in_cwd then final = cwd_indicator .. final end
  return final
end

return M

