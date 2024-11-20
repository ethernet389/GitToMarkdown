# git-to-md.nvim
Plugin generating **Markdown** from **Git** commit history

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

        require('git-to-md').setup(formats)
      end
    }
  })
```

## Requirements
- Neovim
- git

## Commands
`:GitToMd path/to/file` - create git history and write into `path/to/file`

`:GitToMdBuffer` - create git history and save into clipboard

## Configuration
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

# Example of Commit History

## <span style="color:pink"> main</span>
### <span style=color:tomato>refactor(*): Initial commit</span>
- **Hash:** 7715a90
- **Date:** 2024-11-18
- **Author:** Gleb Simakov \<ethernet389@gmail.com\>
- **UNIX Timestamp:** 1731883578
- **Time:** 01:46:18 +0300
- **File state:**
  - <span style="color:chartreuse">***A*** &nbsp;&nbsp;  docs/README.md</span>
  - <span style="color:chartreuse">***A*** &nbsp;&nbsp;  lua/git-to-md/plugin.lua</span>

## <span style="color:pink"> feature</span>
### <span style=color:tomato>refactor(lua/git-to-md/init.lua): Add responses to user</span>
- **Hash:** 33f835c
- **Date:** 2024-11-20
- **Author:** Gleb Simakov \<ethernet389@gmail.com\>
- **UNIX Timestamp:** 1732133384
- **Time:** 23:09:44 +0300
- **File state:**
  - <span style="color:yellow">***M*** &nbsp;&nbsp;  lua/git-to-md/init.lua</span>

### <span style=color:tomato>refactor(lua/git-to-md/{converter.lua init.lua}): Add error notification and saving to buffer</span>
- **Hash:** cd88b5b
- **Date:** 2024-11-20
- **Author:** Gleb Simakov \<ethernet389@gmail.com\>
- **UNIX Timestamp:** 1732129578
- **Time:** 22:06:18 +0300
- **File state:**
  - <span style="color:yellow">***M*** &nbsp;&nbsp;  lua/git-to-md/converter.lua</span>
  - <span style="color:yellow">***M*** &nbsp;&nbsp;  lua/git-to-md/init.lua</span>

### <span style=color:tomato>refactor+style(*): Integrate nvim and style functions in snake_case</span>
- **Hash:** cf4b3a9
- **Date:** 2024-11-20
- **Author:** Gleb Simakov \<ethernet389@gmail.com\>
- **UNIX Timestamp:** 1732122405
- **Time:** 20:06:45 +0300
- **File state:**
  - <span style="color:crimson">***D*** &nbsp;&nbsp;  hello.md</span>
  - <span style="color:yellow">***M*** &nbsp;&nbsp;  lua/git-to-md/converter.lua</span>
  - <span style="color:yellow">***M*** &nbsp;&nbsp;  lua/git-to-md/formats.lua</span>
  - <span style="color:yellow">***M*** &nbsp;&nbsp;  lua/git-to-md/init.lua</span>
  - <span style="color:crimson">***D*** &nbsp;&nbsp;  plugin/git-to-md.vim</span>

### <span style=color:tomato>refactor(*): do commit</span>
- **Hash:** 5edb3e1
- **Date:** 2024-11-20
- **Author:** Gleb Simakov \<ethernet389@gmail.com\>
- **UNIX Timestamp:** 1732109130
- **Time:** 16:25:30 +0300
- **File state:**
  - <span style="color:chartreuse">***A*** &nbsp;&nbsp;  hello.md</span>
  - <span style="color:yellow">***M*** &nbsp;&nbsp;  lua/git-to-md/converter.lua</span>
  - <span style="color:yellow">***M*** &nbsp;&nbsp;  lua/git-to-md/formats.lua</span>
  - <span style="color:crimson">***D*** &nbsp;&nbsp;  lua/git-to-md/git-to-md.lua</span>
  - <span style="color:chartreuse">***A*** &nbsp;&nbsp;  lua/git-to-md/init.lua</span>
  - <span style="color:chartreuse">***A*** &nbsp;&nbsp;  plugin/git-to-md.vim</span>

### <span style=color:tomato>refactor(lua/git-to-md/*): Create converter module</span>
- **Hash:** b124987
- **Date:** 2024-11-18
- **Author:** Gleb Simakov \<ethernet389@gmail.com\>
- **UNIX Timestamp:** 1731961805
- **Time:** 23:30:05 +0300
- **File state:**
  - <span style="color:violet">***R084*** &nbsp;&nbsp;  lua/git-to-md/plugin.lua lua/git-to-md/converter.lua</span>
  - <span style="color:chartreuse">***A*** &nbsp;&nbsp;  lua/git-to-md/git-to-md.lua</span>

### <span style=color:tomato>refactor(lua/git-to-md/*): Separate formats and main logic</span>
- **Hash:** eff5e28
- **Date:** 2024-11-18
- **Author:** Gleb Simakov \<ethernet389@gmail.com\>
- **UNIX Timestamp:** 1731960529
- **Time:** 23:08:49 +0300
- **File state:**
  - <span style="color:chartreuse">***A*** &nbsp;&nbsp;  lua/git-to-md/formats.lua</span>
  - <span style="color:yellow">***M*** &nbsp;&nbsp;  lua/git-to-md/plugin.lua</span>

### <span style=color:tomato>refactore(lua/git-to-md): Update format</span>
- **Hash:** 9ff1b16
- **Date:** 2024-11-18
- **Author:** Gleb Simakov \<ethernet389@gmail.com\>
- **UNIX Timestamp:** 1731928820
- **Time:** 14:20:20 +0300
- **File state:**
  - <span style="color:chartreuse">***A*** &nbsp;&nbsp;  .gitignore</span>
  - <span style="color:crimson">***D*** &nbsp;&nbsp;  lua/git-to-md/.tmp.lua.txt</span>
  