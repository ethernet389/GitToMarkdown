require('git-to-md.converter')
require('git-to-md.formats')

local plugin = {}

plugin.git_to_markdown = function(filename)
  local branches = conv.set_branches()
  conv.get_branch_commits(branches)
  conv.create_markdown(branches, filename)
end

plugin.setup = function (new_formats)
  formats.set(new_formats)

  vim.api.nvim_create_user_command(
    'GitToMd',
    function (opts)
      plugin.git_to_markdown(opts.fargs[1])
    end,
    { nargs = 1 }
  )

  vim.api.nvim_create_user_command(
    'GitToMd',
    function ()
      plugin.git_to_markdown("output.md")
    end,
    { nargs = 0 }
  )
end

return plugin