_G.formats = {}

formats.history_block = '# Commit History\n'

formats.branch_block =  '\n## %s'

formats.time = '%H:%M:%S %z'
formats.commit_block =
'\n### %s%n' ..
'- **Hash:** %h%n' ..
'- **Date:** %as%n' ..
'- **Author:** %an \\<%ae\\>%n' ..
'- **UNIX Timestamp:** %at%n' ..
'- **Time:** %ad%n' ..
'- **File state:**'

formats.state_wrapper = '<span style="color:%s">***%s*** &nbsp;&nbsp; %s</span>\n'
formats.state_colors = {
  ['A'] = 'chartreuse',  -- Added
  ['M'] = 'yellow',      -- Modified
  ['D'] = 'crimson',     -- Deleted
  ['R'] = 'violet',      -- Renamed
  ['T'] = 'sandybrown',  -- Type changed
  ['C'] = 'aquamarine',  -- Copied
  ['U'] = 'red',         -- Unmerged
  ['X'] = 'deeppink'     -- Unknown
}

return formats