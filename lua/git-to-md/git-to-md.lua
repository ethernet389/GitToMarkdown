require("converter")

local branches = conv.GetBranches()
conv.GetBranchCommits(branches)
conv.CreateMarkdown(branches, "output.md")