require('git-to-md.converter')
require('git-to-md.formats')

local M = {}

local git_to_markdown = function(filename)
  local msg = conv.dir_is_repository()
  if msg then
    return msg
  end

  local branches = conv.set_branches()
  conv.get_branch_commits(branches)
  conv.create_markdown(branches, filename)
end

local git_markdown_buffer = function ()
  local tmp_filename = ".there_is_nothing_to_see.go_away.tmp.lua.txt.lol.out"
  local msg = git_to_markdown(tmp_filename)
  if msg then
    return
  end

  local markdown = io.open(tmp_filename, "r")
  if not markdown then
    error("Can't open " .. tmp_filename .. "!")
  end
  local text = markdown:read("a")

  vim.fn.setreg('+', text)

  markdown:close()
  os.remove(tmp_filename)
end

M.setup = function (new_formats)
  formats.set(new_formats)

  vim.api.nvim_create_user_command(
    'GitToMd',
    function (opts)
      local msg = git_to_markdown(opts.fargs[1])
      if msg then
        vim.api.nvim_err_writeln(msg)
      else
        vim.api.nvim_out_write("Git history write in the " .. opts.fargs[1] .. "\n")
      end
    end,
    { nargs = 1 }
  )

  vim.api.nvim_create_user_command(
    'GitToMdBuffer',
    function ()
      local msg = git_markdown_buffer()
      if msg then
        vim.api.nvim_err_writeln(msg)
      else
        vim.api.nvim_out_write("Git history saved in the clipboard\n")
      end
    end,
    {}
  )
end

return M