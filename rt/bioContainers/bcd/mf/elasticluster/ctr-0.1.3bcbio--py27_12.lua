local help_message = [[
This is a module file for the container quay.io/biocontainers/elasticluster:0.1.3bcbio--py27_12, which exposes the
following programs:

 - ansible
 - ansible-doc
 - ansible-galaxy
 - ansible-playbook
 - ansible-pull
 - ansible-vault
 - asadmin
 - bundle_image
 - cfadmin
 - cq
 - cwutil
 - dynamodb_dump
 - dynamodb_load
 - elasticluster
 - elbadmin
 - fetch_file
 - gflags2man.py
 - glacier
 - instance_events
 - kill_instance
 - launch_instance
 - list_instances
 - lss3
 - mturk
 - pyami_sendmail
 - pyrsa-decrypt
 - pyrsa-decrypt-bigfile
 - pyrsa-encrypt
 - pyrsa-encrypt-bigfile
 - pyrsa-keygen
 - pyrsa-priv2pub
 - pyrsa-sign
 - pyrsa-verify
 - route53
 - s3put
 - sdbadmin
 - taskadmin

This container was pulled from:

	https://quay.io/repository/biocontainers/elasticluster

If you encounter errors in elasticluster or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/elasticluster

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: elasticluster")
whatis("Version: ctr-0.1.3bcbio--py27_12")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The elasticluster package")
whatis("URL: https://quay.io/repository/biocontainers/elasticluster")

set_shell_function("ansible",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible $*')
set_shell_function("ansible-doc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible-doc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible-doc $*')
set_shell_function("ansible-galaxy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible-galaxy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible-galaxy $*')
set_shell_function("ansible-playbook",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible-playbook $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible-playbook $*')
set_shell_function("ansible-pull",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible-pull $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible-pull $*')
set_shell_function("ansible-vault",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible-vault $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg ansible-vault $*')
set_shell_function("asadmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg asadmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg asadmin $*')
set_shell_function("bundle_image",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg bundle_image $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg bundle_image $*')
set_shell_function("cfadmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg cfadmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg cfadmin $*')
set_shell_function("cq",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg cq $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg cq $*')
set_shell_function("cwutil",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg cwutil $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg cwutil $*')
set_shell_function("dynamodb_dump",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg dynamodb_dump $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg dynamodb_dump $*')
set_shell_function("dynamodb_load",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg dynamodb_load $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg dynamodb_load $*')
set_shell_function("elasticluster",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg elasticluster $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg elasticluster $*')
set_shell_function("elbadmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg elbadmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg elbadmin $*')
set_shell_function("fetch_file",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg fetch_file $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg fetch_file $*')
set_shell_function("gflags2man.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg gflags2man.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg gflags2man.py $*')
set_shell_function("glacier",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg glacier $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg glacier $*')
set_shell_function("instance_events",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg instance_events $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg instance_events $*')
set_shell_function("kill_instance",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg kill_instance $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg kill_instance $*')
set_shell_function("launch_instance",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg launch_instance $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg launch_instance $*')
set_shell_function("list_instances",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg list_instances $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg list_instances $*')
set_shell_function("lss3",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg lss3 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg lss3 $*')
set_shell_function("mturk",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg mturk $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg mturk $*')
set_shell_function("pyami_sendmail",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyami_sendmail $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyami_sendmail $*')
set_shell_function("pyrsa-decrypt",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-decrypt $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-decrypt $*')
set_shell_function("pyrsa-decrypt-bigfile",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-decrypt-bigfile $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-decrypt-bigfile $*')
set_shell_function("pyrsa-encrypt",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-encrypt $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-encrypt $*')
set_shell_function("pyrsa-encrypt-bigfile",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-encrypt-bigfile $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-encrypt-bigfile $*')
set_shell_function("pyrsa-keygen",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-keygen $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-keygen $*')
set_shell_function("pyrsa-priv2pub",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-priv2pub $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-priv2pub $*')
set_shell_function("pyrsa-sign",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-sign $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-sign $*')
set_shell_function("pyrsa-verify",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-verify $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg pyrsa-verify $*')
set_shell_function("route53",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg route53 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg route53 $*')
set_shell_function("s3put",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg s3put $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg s3put $*')
set_shell_function("sdbadmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg sdbadmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg sdbadmin $*')
set_shell_function("taskadmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg taskadmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elasticluster/elasticluster-0.1.3bcbio--py27_12.simg taskadmin $*')
