-- -*- lua -*-

local defaultcluster = os.getenv("VSC_DEFAULT_CLUSTER_MODULE") or ""

if defaultcluster ~= "" then
    load("cluster/" .. defaultcluster)
else
    LmodError([[No default cluster can be loaded. You need to choose one: 'ml spider cluster' gives an overview]])
end
