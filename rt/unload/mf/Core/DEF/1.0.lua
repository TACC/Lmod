setenv("D2_DIR","FOO")
setenv("D2_TEST",os.getenv("D2_DIR"))
depends_on("ACME")
setenv("DUMMY_TEST",os.getenv("ACME_DIR"))
