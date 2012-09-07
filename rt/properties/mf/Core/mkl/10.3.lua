setenv("TACC_MKL_DIR", "/opt/apps/mkl/10.3")

add_property("arch","offload:mic")
remove_property("arch","mic")
remove_property("arch","offload")
add_property("arch","offload")
add_property("arch","mic")
