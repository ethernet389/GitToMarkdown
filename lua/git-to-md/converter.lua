require("git-to-md.formats")

_G.conv = {}

local tmp_file = ".there_is_nothing_to_see.go_away.tmp.lua.txt.lol"

local git_check = 'git rev-parse --git-dir'
local get_branches = 'git for-each-ref --format="%(refname:short)" refs/heads'
local get_branch_commits = 'git rev-list %s --'
local get_commit_files = 'git show %s --name-status --pretty=""'
local get_commit_info = 'git log --format="%s" --date=format:"%s" -1 %s'

conv.dir_is_repository = function()
  os.execute(git_check .. ' 1> ' .. tmp_file .. ' 2> ' .. tmp_file .. '.err')

  local prompt = io.open(tmp_file, "r")
  if not prompt then
    error("Can't open " .. tmp_file .. "!")
  end

  local msg = prompt:read("a")
  if msg == "" then
    return "Current directory is not repository!"
  end

  os.remove(tmp_file)
  os.remove(tmp_file .. '.err')
end

conv.get_branches = function()
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
  os.remove(tmp_file)
  return branches
end

conv.get_branch_commits = function(branches)
  for branch, commits in pairs(branches) do
    os.execute(get_branch_commits:format(branch) .. ">" .. tmp_file)

    local file_commits = io.open(tmp_file)
    if not file_commits then
      error(("Can't open file withgit rev-parse --git-dir %s commits!"):format(branch))
    end

    for commit in file_commits:lines() do
      commits[#commits + 1] = commit
    end

    file_commits:close()
  end
  os.remove(tmp_file)
end

local function find_white_space(str)
  for idx = 1, #str do
    if str:sub(idx, idx) == ' ' then
      return idx
    end
  end
end

conv.write_commit_info = function(output, commit)
  local commit_info =
    get_commit_info:format(
      formats.commit_block,
      formats.time_format,
      commit
    )

  os.execute(commit_info .. ">" .. tmp_file)
  local tmp = io.open(tmp_file, "r")
  if not tmp then
    error("Can't open temporary file!")
  end

  output:write(tmp:read("a"))
  tmp:close()
  os.remove(tmp_file)
end

conv.write_files_of_commit = function(output, commit)
  os.execute(get_commit_files:format(commit) .. ">" .. tmp_file)
  local tmp = io.open(tmp_file, "r")
  if not tmp then
    error("Can't open temporary file!")
  end

  for file_state in tmp:lines() do
    file_state = file_state:gsub('%s+', ' ')
    local idx = find_white_space(file_state) - 1
    local state, file = file_state:sub(1, idx), file_state:sub(idx + 1, #file_state)
    local color = formats.state_colors[state:sub(1, 1)]
    local str = formats.state_wrapper:format(color, state, file)

    output:write("  - " .. str)
  end

  tmp:close()
  os.remove(tmp_file)
end

conv.create_markdown = function(branches, filename)
  local output = io.open(filename, "w")
  if not output then
    error("Can't open output file!")
  end

  output:write(formats.history_block)

  for branch, commits in pairs(branches) do
    output:write(formats.branch_block:format(branch))

    for _, commit in pairs(commits) do
      conv.write_commit_info(output, commit)
      conv.write_files_of_commit(output, commit)
    end

  end
end

return conv