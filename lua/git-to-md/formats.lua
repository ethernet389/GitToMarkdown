_G.formats = {}

formats.history_block = '# Commit History\n'

formats.branch_block =  '\n## %s'

formats.time_format = '%H:%M:%S %z'
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

formats.set = function (new_formats)
  if not new_formats then
    return
  end
  
  formats.history_block = new_formats.history_block or formats.history_block
  formats.branch_block  = new_formats.branch_block  or formats.branch_block
  formats.time_format   = new_formats.time_format   or formats.time_format
  formats.commit_block  = new_formats.commit_block  or formats.commit_block
  formats.state_wrapper = new_formats.state_wrapper or formats.state_wrapper
  formats.state_colors  = new_formats.state_colors  or formats.state_colors
end

return formats