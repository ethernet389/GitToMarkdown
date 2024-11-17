_G.config = {}

-- Config part --
local heading_name = '# Commit History'

local state_colors = {
  ['A'] = 'green',
  ['M'] = 'yellow',
  ['D'] = 'red'
}
local state_wrapper = '<span style="color:%s">***[%s]*** %s</span>'

local date = '%H:%M:%S %z'

local pretty =
'### %s%n' ..
'- **Hash:** %h%n' ..
'- **Date:** %as%n' ..
'- **Author:** %an \\<%ae\\>%n' ..
'- **UNIX Timestamp:** %at%n' ..
'- **Time:** %ad%n' ..
'- **File state:**'

local params = {date, pretty}
local git_log =
'git log --all --date-order --name-status --no-decorate --date=format:"%s" --pretty=format:"%s"'

local git_branch = 'git branch --list --format="%(refname:short)"'

-- Initial part --
config.heading = function()
  return heading_name
end

config.colorize = function(str)
  local state, file = str:sub(1, 1), str:sub(1, #str)

  return state_wrapper:format(state_colors[state], state, file)
end

config.git_log = function()
  return git_log:format(table.unpack(params))
end

config.git_branch = function ()
  return git_branch
end

return _G.config