# -*- lua -*-
propT = {
   lmod = {
      validT = { sticky = 1 },
      displayT = {
         sticky = { short = "(S)",  long = "(S)",   color = "red", doc = "Module is Sticky, requires --force to unload or purge",  },
      },
   },
   arch = {
      validT = { mic = 1, offload = 1, gpu = 1, },
      displayT = {
         ["devel"] = { short = "(t)",  long = "(t)", color = "red" , doc = "Tools for development",},
      },
   },
}
