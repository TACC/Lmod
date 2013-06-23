if (myShellName() == "bash") then
   pushenv("RTM_SETTARG_CMD", "SETTARG_CMD")
else
   pushenv("RTM_SETTARG_CMD", "SETTARG_CMD_CSH")
end

