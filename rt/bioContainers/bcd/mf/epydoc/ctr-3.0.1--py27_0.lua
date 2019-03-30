local help_message = [[
This is a module file for the container quay.io/biocontainers/epydoc:3.0.1--py27_0, which exposes the
following programs:

 - apirst2html.py
 - epydoc
 - epydocgui

This container was pulled from:

	https://quay.io/repository/biocontainers/epydoc

If you encounter errors in epydoc or need help running the
tools it contains, please contact the developer at

	http://epydoc.sf.net/

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: epydoc")
whatis("Version: ctr-3.0.1--py27_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: Epydoc is a tool for generating API documentation for Python modules ased on their docstrings.  A lightweight markup language called epytext can be used to format docstrings and to add information about specific fields, such as parameters and instance variables.  Epydoc also understands docstrings written in ReStructuredText, Javadoc, and plaintext.
")
whatis("URL: https://quay.io/repository/biocontainers/epydoc")

set_shell_function("apirst2html.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epydoc/epydoc-3.0.1--py27_0.simg apirst2html.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epydoc/epydoc-3.0.1--py27_0.simg apirst2html.py $*')
set_shell_function("epydoc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epydoc/epydoc-3.0.1--py27_0.simg epydoc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epydoc/epydoc-3.0.1--py27_0.simg epydoc $*')
set_shell_function("epydocgui",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epydoc/epydoc-3.0.1--py27_0.simg epydocgui $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epydoc/epydoc-3.0.1--py27_0.simg epydocgui $*')
