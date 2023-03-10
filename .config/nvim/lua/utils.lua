local fn = vim.fn

-- inspect something
function Inspect(item)
  vim.pretty_print(item)
end

local M = {}

function M.executable(name)
  if fn.executable(name) > 0 then
    return true
  end

  return false
end

function M.may_create_dir()
  local fpath = fn.expand('<afile>')
  local parent_dir = fn.fnamemodify(fpath, ":p:h")
  local res = fn.isdirectory(parent_dir)

  if res == 0 then
    fn.mkdir(parent_dir, 'p')
  end
end

function M.nmap(l, r, opts)
    opts = vim.tbl_extend("force", {noremap = true, silent = true}, opts or {})
    vim.keymap.set("n", l, r, opts)
end

function M.vmap(l, r, opts)
    opts = vim.tbl_extend("force", {noremap = true, silent = true}, opts or {})
    vim.keymap.set("v", l, r, opts)
end

function M.imap(l, r, opts)
    opts = vim.tbl_extend("force", {noremap = true, silent = true}, opts or {})
    vim.keymap.set("i", l, r, opts)
end

function M.xmap(l, r, opts)
    opts = vim.tbl_extend("force", {noremap = true, silent = true}, opts or {})
    vim.keymap.set("x", l, r, opts)
end

return M
