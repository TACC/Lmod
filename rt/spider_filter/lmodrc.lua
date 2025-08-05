filter_spider_cache_by_modulepath = true

scDescriptT = {
  {
    ["dir"]      =  os.getenv("PROD_CACHE_DIR"),
    ["timestamp"] = os.getenv("PROD_TIMESTAMP_FILE"),
  },
  {
    ["dir"]      =  os.getenv("TEST_CACHE_DIR"),
    ["timestamp"] = os.getenv("TEST_TIMESTAMP_FILE"),
  },
}
