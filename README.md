# git-to-md.nvim
Plugin generating **Markdown** from **Git** commit history

> [!NOTE]
> **Github** does not support colors 
> so if you want to use colors,
> then convert **Markdown** to **Image**.

> [!TIP] 
> To convert to image you can use tool [mdimg](https://www.npmjs.com/package/mdimg).

## Installation
### Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```Lua
require("lazy").setup({
    {
      'ethernet389/git-to-md.nvim',
      config = function()
        local formats = {
          history_block = '# Commit History\n',
          branch_block =  '\n## %s',
          time_format = '%H:%M:%S %z',
          commit_block =
            '\n### %s%n' ..
            '- **Hash:** %h%n' ..
            '- **Date:** %as%n' ..
            '- **Author:** %an \\<%ae\\>%n' ..
            '- **UNIX Timestamp:** %at%n' ..
            '- **Time:** %ad%n' ..
            '- **File state:**', -- After the commit there are files
          
          -- Parameters: State (Down table), State (Down table), filename
          state_wrapper = '<span style="color:%s">***%s*** &nbsp;&nbsp; %s</span>\n',
          state_colors = {
            ['A'] = 'chartreuse',  -- Added
            ['M'] = 'yellow',      -- Modified
            ['D'] = 'crimson',     -- Deleted
            ['R'] = 'violet',      -- Renamed
            ['T'] = 'sandybrown',  -- Type changed
            ['C'] = 'aquamarine',  -- Copied
            ['U'] = 'red',         -- Unmerged
            ['X'] = 'deeppink'     -- Unknown
          }
        }

        local clipboard_name = "cp"

        require('git-to-md').setup(formats, clipboard_name)
      end
    }
  })
```

## Requirements
- Neovim
- git

## Commands
`:GitToMd path/to/file branch1 branch2 branch3...` 
- Create git history of selected branches and write into `path/to/file`
<br></br>

`:GitToMdBuffer clipboard_name branch1 branch2 branch3...` 
- Create git history of selected branches and save into clipboard 
<br></br>

> [!WARNING]
> Be careful when copying to the clipboard. It may **overflow**.

> [!NOTE]
> The first argument is **required**, the next ones are not, and they contain the branch names. By default git history contains **all** branches.

## Configuration
`clipboard_name` - it's set name for clipboard of first argument in nvim

You can set custom style in **formats**

---
### formats.history_block
Format of header of the commit history block

**Default value:** `'# Commit History\n'`

---
### formats.branch_block
Format of header of the branch block

**Default value:** `'\n## %s'`

**Parameters:**
- `%s` - branch name

---
### formats.commit_block
Format for each commit. After commit there are list of changes in files

**Default value:**
```Lua
'\n### %s%n' ..
'- **Hash:** %h%n' ..
'- **Date:** %as%n' ..
'- **Author:** %an \\<%ae\\>%n' ..
'- **UNIX Timestamp:** %at%n' ..
'- **Time:** %ad%n' ..
'- **File state:**'
```

**Flags** are the same as in **git log --pretty=format:"..."**

For additional info read this: [git pretty formats](https://git-scm.com/docs/pretty-formats)

---
### formats.time_format
Format time and date for each commit_block (is **%ad** flag)

**Default value:** `'%H:%M:%S %z'`

**Flags** are the same as in **git log --date=format:"..."**

|    Flag    | Description                                                                 |
|:------------:|--------------------------------------------------------------------------|
| ``%a``      | Abbreviated weekday name                                                |
| ``%A``      | Full weekday name                                                       |
| ``%b``      | Abbreviated month name                                                  |
| ``%B``      | Full month name                                                         |
| ``%c``      | Date and time representation appropriate for locale                     |
| ``%d``      | Day of month as decimal number (01 – 31)                               |
| ``%H``      | Hour in 24-hour format (00 – 23)                                       |
| ``%I``      | Hour in 12-hour format (01 – 12)                                       |
| ``%j``      | Day of year as decimal number (001 – 366)                              |
| ``%m``      | Month as decimal number (01 – 12)                                      |
| ``%M``      | Minute as decimal number (00 – 59)                                     |
| ``%p``      | Current locale's A.M./P.M. indicator for 12-hour clock                 |
| ``%S``      | Second as decimal number (00 – 59)                                     |
| ``%U``      | Week of year as decimal number, with Sunday as first day of week (00 – 53) |
| ``%w``      | Weekday as decimal number (0 – 6; Sunday is 0)                         |
| ``%W``      | Week of year as decimal number, with Monday as first day of week (00 – 53) |
| ``%x``      | Date representation for current locale                                   |
| ``%X``      | Time representation for current locale                                   |
| ``%y``      | Year without century, as decimal number (00 – 99)                      |
| ``%Y``      | Year with century, as decimal number                                    |
| ``%z, %Z``  | Either the time-zone name or time zone abbreviation, depending on registry settings |
| ``%%``      | Percent sign                                                            |


---
### formats.state_wrapper
Display each file state (Added, Removed, Updated...) and filename

**Default value:** `<span style="color:%s">***%s*** &nbsp;&nbsp; %s</span>\n`

**Parameters (numerated in order):**
1. `%s` - **Color** connected with file state (look `formats.state_colors`)
2. `%s` - File state (`A`, `D`, `U`, ...)
3. `%s` - Filename

---
### formats.state_colors
Table of colors connected with each file state in **git**

**Default value:**
```Lua
{
  ['A'] = 'chartreuse',  -- Added
  ['M'] = 'yellow',      -- Modified
  ['D'] = 'crimson',     -- Deleted
  ['R'] = 'violet',      -- Renamed
  ['T'] = 'sandybrown',  -- Type changed
  ['C'] = 'aquamarine',  -- Copied
  ['U'] = 'red',         -- Unmerged
  ['X'] = 'deeppink'     -- Unknown
}
```
`['Git file state'] = 'HTML color code (or RGB)'`

# Author
Глеб Симаков M3101 467462

![example](example.png)
