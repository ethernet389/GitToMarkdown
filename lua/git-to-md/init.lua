require('lua.git-to-md.converter')

_G.git_to_md = {}

git_to_md.GitToMarkdown = function(filename)
  local branches = conv.GetBranches()
  conv.GetBranchCommits(branches)
  conv.CreateMarkdown(branches, filename)
end

-- vim.api.nvim_create_user_command('GitToMd',
--                                  git_to_md.GitToMarkdown("output.md"), {})

return git_to_md