if exists("g:loaded_gtm_plugin")
  finish
endif
let g:loaded_gtm_plugin = 1

let s:lua_location = expand("<sfile>:h:r") . "/../lua/git-to-md/"
exe "lua package.path = package.path ..';" . s:lua_location . "/lua-?/init.lua"

command! -nargs=0 GTM lua require("git-to-md").GitToMarkdown("output.md")