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

formats.state_wrapper = '<span style="color:%s">***[%s]*** %s</span>\n'
formats.state_colors = {
  ['A'] = 'green',
  ['M'] = 'yellow',
  ['D'] = 'red'
}

return formats