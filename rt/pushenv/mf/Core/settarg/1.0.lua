if (myShellName() == "bash" or myShellName() == "zsh" ) then
   pushenv("RTM_SETTARG_CMD", "SETTARG_CMD")
else
   pushenv("RTM_SETTARG_CMD", "SETTARG_CMD_CSH")
end

