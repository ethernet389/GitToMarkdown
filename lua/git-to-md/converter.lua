require("formats")

_G.conv = {}

local tmp_file = ".tmp.lua.txt"

local get_branches = 'git for-each-ref --format="%(refname:short)" refs/heads'
local get_branch_commits = 'git rev-list %s'
local get_commit_files = 'git show %s --name-status --pretty=""'
local get_commit_info = 'git log --format="%s" --date=format:"%s" -1 %s'


conv.GetBranches = function()
  os.execute(get_branches .. ">" .. tmp_file)
  local branch_file = io.open(tmp_file)
  if not branch_file then
    error("Can't open temporary file with branches!")
  end

  local branches = {}
  for branch in branch_file:lines() do
    branches[branch] = {}
  end

  io.close()
  return branches
end

conv.GetBranchCommits = function(branches)
  for branch, commits in pairs(branches) do
    os.execute(get_branch_commits:format(branch) .. ">" .. tmp_file)

    local file_commits = io.open(tmp_file)
    if not file_commits then
      error(("Can't open file with %s commits!"):format(branch))
    end

    for commit in file_commits:lines() do
      commits[#commits + 1] = commit
    end

    file_commits:close()
  end
end

conv.WriteCommitInfo = function(output, commit)
  local commit_info = get_commit_info:format(formats.commit_block, formats.time, commit)
  os.execute(commit_info .. ">" .. tmp_file)
  local tmp = io.open(tmp_file, "r")
  if not tmp then
    error("Can't open temporary file!")
  end

  output:write(tmp:read("a"))
  tmp:close()
  os.remove(tmp_file)
end

conv.WriteFilesOfCommit = function(output, commit)
  os.execute(get_commit_files:format(commit) .. ">" .. tmp_file)
  local tmp = io.open(tmp_file, "r")
  if not tmp then
    error("Can't open temporary file!")
  end

  for file_state in tmp:lines() do
    local state, file = file_state:sub(1, 1), file_state:sub(2, #file_state)
    local str = formats.state_wrapper:format(formats.state_colors[state], state, file)

    output:write("  - " .. str)
  end

  tmp:close()
  os.remove(tmp_file)
end

conv.CreateMarkdown = function(branches, filename)
  local output = io.open(filename, "w")
  if not output then
    error("Can't open output file!")
  end

  output:write(formats.history_block)

  for branch, commits in pairs(branches) do
    output:write(formats.branch_block:format(branch))

    for _, commit in pairs(commits) do
      conv.WriteCommitInfo(output, commit)
      conv.WriteFilesOfCommit(output, commit)
    end

  end
end

return conv