
function Output(shell)
   local masterTbl  = masterTbl()
   local envVarsTbl = masterTbl.envVarsTbl

   shell:expand(envVarsTbl)
   
end
