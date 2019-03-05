local help_message = [[
This is a module file for the container quay.io/biocontainers/ectyper:0.8.1--py_0, which exposes the
following programs:

 - bcftools
 - blast_formatter
 - blastdb_aliastool
 - blastdbcheck
 - blastdbcmd
 - blastdbcp
 - blastn
 - blastp
 - blastx
 - bowtie2
 - bowtie2-align-l
 - bowtie2-align-s
 - bowtie2-build
 - bowtie2-build-l
 - bowtie2-build-s
 - bowtie2-inspect
 - bowtie2-inspect-l
 - bowtie2-inspect-s
 - capnp
 - capnpc
 - capnpc-c++
 - capnpc-capnp
 - certtool
 - color-chrs.pl
 - conv-template
 - convert2blastmask
 - datatool
 - deltablast
 - dustmasker
 - ectyper
 - from-template
 - gene_info_reader
 - gnutls-cli
 - gnutls-cli-debug
 - gnutls-serv
 - guess-ploidy.py
 - legacy_blast.pl
 - makeblastdb
 - makembindex
 - makeprofiledb
 - mash
 - ncurses6-config
 - nettle-hash
 - nettle-lfib-stream
 - nettle-pbkdf2
 - ocsptool
 - perl5.26.2
 - pkcs1-conv
 - plot-roh.py
 - plot-vcfstats
 - project_tree_builder
 - psiblast
 - psktool
 - py.test
 - pytest
 - rpsblast
 - rpstblastn
 - run-roh.pl
 - run_with_lock
 - samtools
 - seedtop
 - segmasker
 - seqdb_demo
 - seqdb_perf
 - seqtk
 - sexp-conv
 - srptool
 - tblastn
 - tblastx
 - update_blastdb.pl
 - update_blastdb.pl.bak
 - vcfutils.pl
 - windowmasker
 - windowmasker_2.2.22_adapter.py

This container was pulled from:

	https://quay.io/repository/biocontainers/ectyper

If you encounter errors in ectyper or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/ectyper

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: ectyper")
whatis("Version: ctr-0.8.1--py_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ectyper package")
whatis("URL: https://quay.io/repository/biocontainers/ectyper")

set_shell_function("bcftools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bcftools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bcftools $*')
set_shell_function("blast_formatter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blast_formatter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blast_formatter $*')
set_shell_function("blastdb_aliastool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastdb_aliastool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastdb_aliastool $*')
set_shell_function("blastdbcheck",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastdbcheck $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastdbcheck $*')
set_shell_function("blastdbcmd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastdbcmd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastdbcmd $*')
set_shell_function("blastdbcp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastdbcp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastdbcp $*')
set_shell_function("blastn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastn $*')
set_shell_function("blastp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastp $*')
set_shell_function("blastx",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastx $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg blastx $*')
set_shell_function("bowtie2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2 $*')
set_shell_function("bowtie2-align-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-align-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-align-l $*')
set_shell_function("bowtie2-align-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-align-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-align-s $*')
set_shell_function("bowtie2-build",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-build $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-build $*')
set_shell_function("bowtie2-build-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-build-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-build-l $*')
set_shell_function("bowtie2-build-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-build-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-build-s $*')
set_shell_function("bowtie2-inspect",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-inspect $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-inspect $*')
set_shell_function("bowtie2-inspect-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-inspect-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-inspect-l $*')
set_shell_function("bowtie2-inspect-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-inspect-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg bowtie2-inspect-s $*')
set_shell_function("capnp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg capnp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg capnp $*')
set_shell_function("capnpc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg capnpc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg capnpc $*')
set_shell_function("capnpc-c++",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg capnpc-c++ $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg capnpc-c++ $*')
set_shell_function("capnpc-capnp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg capnpc-capnp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg capnpc-capnp $*')
set_shell_function("certtool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg certtool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg certtool $*')
set_shell_function("color-chrs.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg color-chrs.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg color-chrs.pl $*')
set_shell_function("conv-template",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg conv-template $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg conv-template $*')
set_shell_function("convert2blastmask",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg convert2blastmask $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg convert2blastmask $*')
set_shell_function("datatool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg datatool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg datatool $*')
set_shell_function("deltablast",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg deltablast $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg deltablast $*')
set_shell_function("dustmasker",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg dustmasker $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg dustmasker $*')
set_shell_function("ectyper",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg ectyper $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg ectyper $*')
set_shell_function("from-template",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg from-template $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg from-template $*')
set_shell_function("gene_info_reader",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg gene_info_reader $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg gene_info_reader $*')
set_shell_function("gnutls-cli",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg gnutls-cli $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg gnutls-cli $*')
set_shell_function("gnutls-cli-debug",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg gnutls-cli-debug $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg gnutls-cli-debug $*')
set_shell_function("gnutls-serv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg gnutls-serv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg gnutls-serv $*')
set_shell_function("guess-ploidy.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg guess-ploidy.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg guess-ploidy.py $*')
set_shell_function("legacy_blast.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg legacy_blast.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg legacy_blast.pl $*')
set_shell_function("makeblastdb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg makeblastdb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg makeblastdb $*')
set_shell_function("makembindex",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg makembindex $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg makembindex $*')
set_shell_function("makeprofiledb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg makeprofiledb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg makeprofiledb $*')
set_shell_function("mash",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg mash $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg mash $*')
set_shell_function("ncurses6-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg ncurses6-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg ncurses6-config $*')
set_shell_function("nettle-hash",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg nettle-hash $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg nettle-hash $*')
set_shell_function("nettle-lfib-stream",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg nettle-lfib-stream $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg nettle-lfib-stream $*')
set_shell_function("nettle-pbkdf2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg nettle-pbkdf2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg nettle-pbkdf2 $*')
set_shell_function("ocsptool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg ocsptool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg ocsptool $*')
set_shell_function("perl5.26.2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg perl5.26.2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg perl5.26.2 $*')
set_shell_function("pkcs1-conv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg pkcs1-conv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg pkcs1-conv $*')
set_shell_function("plot-roh.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg plot-roh.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg plot-roh.py $*')
set_shell_function("plot-vcfstats",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg plot-vcfstats $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg plot-vcfstats $*')
set_shell_function("project_tree_builder",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg project_tree_builder $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg project_tree_builder $*')
set_shell_function("psiblast",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg psiblast $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg psiblast $*')
set_shell_function("psktool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg psktool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg psktool $*')
set_shell_function("py.test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg py.test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg py.test $*')
set_shell_function("pytest",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg pytest $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg pytest $*')
set_shell_function("rpsblast",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg rpsblast $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg rpsblast $*')
set_shell_function("rpstblastn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg rpstblastn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg rpstblastn $*')
set_shell_function("run-roh.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg run-roh.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg run-roh.pl $*')
set_shell_function("run_with_lock",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg run_with_lock $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg run_with_lock $*')
set_shell_function("samtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg samtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg samtools $*')
set_shell_function("seedtop",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg seedtop $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg seedtop $*')
set_shell_function("segmasker",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg segmasker $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg segmasker $*')
set_shell_function("seqdb_demo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg seqdb_demo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg seqdb_demo $*')
set_shell_function("seqdb_perf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg seqdb_perf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg seqdb_perf $*')
set_shell_function("seqtk",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg seqtk $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg seqtk $*')
set_shell_function("sexp-conv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg sexp-conv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg sexp-conv $*')
set_shell_function("srptool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg srptool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg srptool $*')
set_shell_function("tblastn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg tblastn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg tblastn $*')
set_shell_function("tblastx",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg tblastx $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg tblastx $*')
set_shell_function("update_blastdb.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg update_blastdb.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg update_blastdb.pl $*')
set_shell_function("update_blastdb.pl.bak",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg update_blastdb.pl.bak $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg update_blastdb.pl.bak $*')
set_shell_function("vcfutils.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg vcfutils.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg vcfutils.pl $*')
set_shell_function("windowmasker",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg windowmasker $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg windowmasker $*')
set_shell_function("windowmasker_2.2.22_adapter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg windowmasker_2.2.22_adapter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.8.1--py_0.simg windowmasker_2.2.22_adapter.py $*')
