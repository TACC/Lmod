# -*- lua -*-
propT = {
   lmod = {
      validT = { sticky = 1 },
      displayT = {
         sticky = { short = "(S)",  long = "(S)",   color = "red", doc = "Module is Sticky, requires --force to unload or purge",  },
      },
   },
   type_ = {
      validT = { tools = 1, mpi = 2, script = 3, math = 4, chem = 5, bio = 6, vis = 7 },
      displayT = {
         ["tools"]     = { short = "(t)",  long = "(tool)",   color = "blue", doc = "Tools for developpement", },
         ["mpi"]     = { short = "(m)",  long = "(mpi)",   color = "red", doc = "MPI implementations", },
         ["script"]     = { short = "(s)",  long = "(script)",   color = "yellow", doc = "Scripting language", },
         ["math"]     = { short = "(math)",  long = "(math)",   color = "green", doc = "Mathematical libraries", },
         ["chem"]     = { short = "(chem)",  long = "(chem)",   color = "magenta", doc = "Chemistry libraries/apps", },
         ["bio"]     = { short = "(bio)",  long = "(bio)",   color = "red", doc = "Bioinformatic libraries/apps", },
         ["vis"]     = { short = "(vis)",  long = "(vis)",   color = "blue", doc = "Visualisation software", },
      },
   },
}

