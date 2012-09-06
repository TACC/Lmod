# -*- lua -*-
propT = {
   arch = {
      validT = { mic = 1, offload = 1, gpu = 1, },
      displayT = {
         ["mic:offload"]     = { short = "(*)",  long = "(m,o)",   color = "magenta",},
         ["mic"]             = { short = "(m)",  long = "(m)",     color = "blue"   ,},
         ["offload"]         = { short = "(o)",  long = "(o)",     color = "blue"   ,},
         ["gpu"]             = { short = "(g)",  long = "(g)",     color = "red"    ,},
         ["gpu:mic"]         = { short = "(gm)", long = "(g,m)",   color = "red"   ,},
         ["gpu:mic:offload"] = { short = "(@)",  long = "(g,m,o)", color = "red"   ,},
      },
   },
}
