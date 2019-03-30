# -*- lua -*-
local i18n = require("i18n")
propT = {
   state = {
      validT = { experimental = 1, testing = 1, obsolete = 1 },
      displayT = {
         experimental  = { short = "(E)",  long = "(E)",     color = "blue",  doc = i18n("ExplM"), },
         testing       = { short = "(T)",  long = "(T)",     color = "green", doc = i18n("TstM"), },
         obsolete      = { short = "(O)",  long = "(O)",     color = "red",   doc = i18n("ObsM"), },
      },
   },
   lmod = {
      validT = { sticky = 1 },
      displayT = {
         sticky = { short = "(S)",  long = "(S)",   color = "red",    doc = i18n("StickyM"), }
      },
   },
   arch = {
      validT = { mic = 1, offload = 1, gpu = 1, },
      displayT = {
         ["mic:offload"]     = { short = "(*)",  long = "(m,o)",   color = "blue", full_color = false, doc = "built for host, native MIC and offload to the MIC",  },
         ["mic"]             = { short = "(m)",  long = "(m)",     color = "blue", full_color = false, doc = "built for host and native MIC", },
         ["offload"]         = { short = "(o)",  long = "(o)",     color = "blue", full_color = false, doc = "built for offload to the MIC only",},
         ["gpu"]             = { short = "(g)",  long = "(g)",     color = "red" , full_color = false, doc = "built for GPU",},
         ["gpu:mic"]         = { short = "(gm)", long = "(g,m)",   color = "red" , full_color = false, doc = "built natively for MIC and GPU",},
         ["gpu:mic:offload"] = { short = "(@)",  long = "(g,m,o)", color = "red" , full_color = false, doc = "built natively for MIC and GPU and offload to the MIC",},
      },
   },
   status = {
      validT = { active = 1, },
      displayT = {
         active = { short = "(L)",  long = "(L)",     color = "yellow", doc = i18n("LoadedM")},
     },
   },
}
