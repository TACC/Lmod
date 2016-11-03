local pkg = "/cm/shared/apps/openblas/0.2.14"
setenv(      "BLASDIR",          pathJoin(pkg,"lib"))
prepend_path("LD_LIBRARY_PATH",  pathJoin(pkg,"lib"))
