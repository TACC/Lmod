local help_message = [[
This is a module file for the container quay.io/biocontainers/expat:2.1.0--0, which exposes the
following programs:

None - please invoke manually

This container was pulled from:

	https://quay.io/repository/biocontainers/expat

If you encounter errors in expat or need help running the
tools it contains, please contact the developer at

	http://www.libexpat.org/

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: expat")
whatis("Version: ctr-2.1.0--0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: Expat is a stream oriented XML parser.  This means that you register handlers with the parser prior to starting the parse.  These handlers are called when the parser discovers the associated structures in the document being parsed.  A start tag is an example of the kind of structures for which you may register handlers.")
whatis("URL: https://quay.io/repository/biocontainers/expat")

