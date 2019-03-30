local help_message = [[
This is a module file for the container quay.io/biocontainers/edittag:1.1--py27_0, which exposes the
following programs:

 - add_tags_to_adapters.py
 - add_tags_to_primers.py
 - design_edit_metric_tags.py
 - estimate_sequencing_error_effects.py
 - get_tag_flows_for_454.py
 - validate_edit_metric_tags.py

This container was pulled from:

	https://quay.io/repository/biocontainers/edittag

If you encounter errors in edittag or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/edittag

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: edittag")
whatis("Version: ctr-1.1--py27_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The edittag package")
whatis("URL: https://quay.io/repository/biocontainers/edittag")

set_shell_function("add_tags_to_adapters.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg add_tags_to_adapters.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg add_tags_to_adapters.py $*')
set_shell_function("add_tags_to_primers.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg add_tags_to_primers.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg add_tags_to_primers.py $*')
set_shell_function("design_edit_metric_tags.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg design_edit_metric_tags.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg design_edit_metric_tags.py $*')
set_shell_function("estimate_sequencing_error_effects.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg estimate_sequencing_error_effects.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg estimate_sequencing_error_effects.py $*')
set_shell_function("get_tag_flows_for_454.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg get_tag_flows_for_454.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg get_tag_flows_for_454.py $*')
set_shell_function("validate_edit_metric_tags.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg validate_edit_metric_tags.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/edittag/edittag-1.1--py27_0.simg validate_edit_metric_tags.py $*')
