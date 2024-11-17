require("config")

local tmp_filename = ".tmp_log_output.md"
local filename = "log_output.md"

os.execute(config.git_log() .. ">" .. tmp_filename)

local output = io.open(filename, "w")
if not output then
  return
end

output:write(config.heading())

local flag = false
for line in io.lines(tmp_filename) do
  if line == "- **File state:**" then
    flag = true
  elseif line:find("###") then
    line = "\n" .. line
    flag = false
  elseif #line ~= 0 and flag then
    line = "  - " .. config.colorize(line)
  end

  output:write(line .. "\n")
end

output:close()
os.remove(tmp_filename)