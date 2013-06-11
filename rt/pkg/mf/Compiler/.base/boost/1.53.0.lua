-- -*- lua -*-
local helpMsg = [[
The boost module file defines the following environment variables:
TACC_BOOST_DIR, TACC_BOOST_LIB, and TACC_BOOST_INC for
the location of the boost distribution.
]]

local pkg = Pkg:new{Category     = "System Environment/Base",
                    URL          = "http://www.boost.org",
                    Description  = "Boost provides free peer-reviewed "..
                                   " portable C++ source libraries.",
                    display_name = "Boost",
                    level        = 1,
                    help         = helpMsg
}
                     
local base = pkg:pkgBase()
setenv( 'TACC_BOOST_LIB',  pathJoin(base,"lib"))
setenv( 'TACC_BOOST_INC',  pathJoin(base,"include"))

add_property("arch","mic")

             
