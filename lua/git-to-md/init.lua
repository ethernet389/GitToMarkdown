require('git-to-md.converter')
require('git-to-md.formats')

local tmp_file = ".there_is_nothing_to_see.go_away.tmp.lua.txt.lol.out"
local validate_branch = "git rev-list %s --"

local M = {}

local git_to_markdown = function(filename, spec_branches)
  local msg = conv.dir_is_repository()
  if msg then
    return msg
  end

  local branches = spec_branches or conv.get_branches()
  conv.get_branch_commits(branches)
  conv.create_markdown(branches, filename)
end

local git_markdown_buffer = function(spec_branches)
  local msg = git_to_markdown(tmp_file, spec_branches)
  if msg then
    return
  end

  local markdown = io.open(tmp_file, "r")
  if not markdown then
    error("Can't open " .. tmp_file .. "!")
  end
  local text = markdown:read("a")

  vim.fn.setreg('+', text)

  markdown:close()
  os.remove(tmp_file)
end

local function get_branches_from_cmd(opts)
  local branches = nil
  if opts.fargs[2] then
    branches = {}
    for _, branch in pairs({ table.unpack(opts.fargs, 2) }) do
      branches[branch] = {}
    end
  end

  return branches
end

local function validate_branches(branches)
  if not branches then
    return nil
  end

  local msg = nil
  for branch, _ in pairs(branches) do
    local command = 
      validate_branch:format(branch) ..
      " 2> " .. tmp_file .. '.err' ..
      " 1> " .. tmp_file
    os.execute(command)

    local output = io.open(tmp_file, "r")
    if not output then
      error("Can't open " .. tmp_file .. "!")
    end

    if output:read("a") == "" then
      msg = 'Branch "' .. branch .. '" doesn\'t exist!\n'
      break
    end
  end

  os.remove(tmp_file .. '.err')
  os.remove(tmp_file)
  return msg
end

local function nvim_git_to_md(opts, clipboard)
  if not opts.fargs[1] then
    vim.api.nvim_err_writeln(
      'Command take at least 1 argument (filename or "' .. clipboard ..'")\n'
    )
    return
  end

  local branches = get_branches_from_cmd(opts)
  local err = validate_branches(branches)
  if err then
    vim.api.nvim_err_writeln(err)
    return
  end

  local msg = ""

  if opts.fargs[1] == clipboard then
    err = git_markdown_buffer(branches)
    msg = "Git history saved in the clipboard\n"
  else
    err = git_to_markdown(opts.fargs[1], branches)
    msg = "Git history write in the " .. opts.fargs[1] .. "\n"
  end

  if err then
    vim.api.nvim_err_writeln(err)
    return
  end

  vim.api.nvim_out_write(msg)

end

M.setup = function (new_formats, clipboard)
  formats.set(new_formats)

  vim.api.nvim_create_user_command(
    'GitToMd',
    function (opts)
      nvim_git_to_md(opts, clipboard or "cp")
    end,
    { nargs = '*' }
  )
end

return M