-- Module with dependencies for testing terse spider output
-- This tests the asymmetry issue: single module should show module name,
-- not prerequisites, in terse mode
depends_on("gcc")
depends_on("intel")
setenv("GMP_VERSION", myModuleVersion())



