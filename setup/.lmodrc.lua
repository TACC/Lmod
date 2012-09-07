# -*- lua -*-
propT = {
   arch = {
      validT = { mic = 1, offload = 1, gpu = 1, },
      displayT = {
         ["mic:offload"]     = { short = "(*)",  long = "(m,o)",   color = "magenta", doc = "module is build natively for MIC and offload to the MIC",  },
         ["mic"]             = { short = "(m)",  long = "(m)",     color = "blue"   , doc = "module is build natively for MIC", },
         ["offload"]         = { short = "(o)",  long = "(o)",     color = "blue"   , doc = "module is build for offload to the MIC",},
         ["gpu"]             = { short = "(g)",  long = "(g)",     color = "red"    , doc = "module is build for GPU",},
         ["gpu:mic"]         = { short = "(gm)", long = "(g,m)",   color = "red"    , doc = "module is build natively for MIC and GPU",},
         ["gpu:mic:offload"] = { short = "(@)",  long = "(g,m,o)", color = "red"    , doc = "module is build natively for MIC and GPU and offload to the MIC",},
      },
   },
}
