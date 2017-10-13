-- -*- lua -*-

BuildScenarioTbl = {
   default                = "empty",
}

HostnameTbl = { 2 }  -- extracts the 2nd part of `hostname -f` output, towards variable $TARG_HOST

TitleTbl = {
   ['cmplr/clang'] = "cmplrC",
}

ModuleTbl = {
   compiler           = { 'cmplr/clang' },
}

