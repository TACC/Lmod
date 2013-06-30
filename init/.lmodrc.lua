# -*- lua -*-
propT = {
   arch = {
      validT = { mic = 1, offload = 1, gpu = 1, },
      displayT = {
         ["mic:offload"]     = { short = "(*)",  long = "(m,o)",   color = "blue", doc = "built for host, native MIC and offload to the MIC",  },
         ["mic"]             = { short = "(m)",  long = "(m)",     color = "blue", doc = "built for host and native MIC", },
         ["offload"]         = { short = "(o)",  long = "(o)",     color = "blue", doc = "built for offload to the MIC only",},
         ["gpu"]             = { short = "(g)",  long = "(g)",     color = "red" , doc = "built for GPU",},
         ["gpu:mic"]         = { short = "(gm)", long = "(g,m)",   color = "red" , doc = "built natively for MIC and GPU",},
         ["gpu:mic:offload"] = { short = "(@)",  long = "(g,m,o)", color = "red" , doc = "built natively for MIC and GPU and offload to the MIC",},
      },
   },
}
