local help_message = [[
This is a module file for the container quay.io/biocontainers/ephemeris:0.8.0--py35_0, which exposes the
following programs:

 - asadmin
 - bioblend-galaxy-tests
 - bundle_image
 - cfadmin
 - cq
 - cwutil
 - dynamodb_dump
 - dynamodb_load
 - elbadmin
 - fetch_file
 - galaxy-wait
 - get-tool-list
 - glacier
 - idle3.5
 - instance_events
 - kill_instance
 - launch_instance
 - list_instances
 - lss3
 - mturk
 - pyami_sendmail
 - python3.5-config
 - python3.5m-config
 - pyvenv-3.5
 - route53
 - run-data-managers
 - s3put
 - sdbadmin
 - setup-data-libraries
 - shed-tools
 - taskadmin
 - workflow-install
 - workflow-to-tools

This container was pulled from:

	https://quay.io/repository/biocontainers/ephemeris

If you encounter errors in ephemeris or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/ephemeris

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: ephemeris")
whatis("Version: ctr-0.8.0--py35_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ephemeris package")
whatis("URL: https://quay.io/repository/biocontainers/ephemeris")

set_shell_function("asadmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg asadmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg asadmin $*')
set_shell_function("bioblend-galaxy-tests",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg bioblend-galaxy-tests $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg bioblend-galaxy-tests $*')
set_shell_function("bundle_image",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg bundle_image $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg bundle_image $*')
set_shell_function("cfadmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg cfadmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg cfadmin $*')
set_shell_function("cq",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg cq $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg cq $*')
set_shell_function("cwutil",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg cwutil $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg cwutil $*')
set_shell_function("dynamodb_dump",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg dynamodb_dump $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg dynamodb_dump $*')
set_shell_function("dynamodb_load",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg dynamodb_load $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg dynamodb_load $*')
set_shell_function("elbadmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg elbadmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg elbadmin $*')
set_shell_function("fetch_file",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg fetch_file $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg fetch_file $*')
set_shell_function("galaxy-wait",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg galaxy-wait $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg galaxy-wait $*')
set_shell_function("get-tool-list",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg get-tool-list $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg get-tool-list $*')
set_shell_function("glacier",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg glacier $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg glacier $*')
set_shell_function("idle3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg idle3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg idle3.5 $*')
set_shell_function("instance_events",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg instance_events $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg instance_events $*')
set_shell_function("kill_instance",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg kill_instance $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg kill_instance $*')
set_shell_function("launch_instance",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg launch_instance $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg launch_instance $*')
set_shell_function("list_instances",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg list_instances $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg list_instances $*')
set_shell_function("lss3",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg lss3 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg lss3 $*')
set_shell_function("mturk",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg mturk $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg mturk $*')
set_shell_function("pyami_sendmail",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg pyami_sendmail $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg pyami_sendmail $*')
set_shell_function("python3.5-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg python3.5-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg python3.5-config $*')
set_shell_function("python3.5m-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg python3.5m-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg python3.5m-config $*')
set_shell_function("pyvenv-3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg pyvenv-3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg pyvenv-3.5 $*')
set_shell_function("route53",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg route53 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg route53 $*')
set_shell_function("run-data-managers",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg run-data-managers $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg run-data-managers $*')
set_shell_function("s3put",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg s3put $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg s3put $*')
set_shell_function("sdbadmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg sdbadmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg sdbadmin $*')
set_shell_function("setup-data-libraries",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg setup-data-libraries $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg setup-data-libraries $*')
set_shell_function("shed-tools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg shed-tools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg shed-tools $*')
set_shell_function("taskadmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg taskadmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg taskadmin $*')
set_shell_function("workflow-install",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg workflow-install $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg workflow-install $*')
set_shell_function("workflow-to-tools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg workflow-to-tools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ephemeris/ephemeris-0.8.0--py35_0.simg workflow-to-tools $*')
