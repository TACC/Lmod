local help_message = [[
This is a module file for the container quay.io/biocontainers/ectyper:0.1--py35_0, which exposes the
following programs:

 - aalookup_unit_test
 - aascan_unit_test
 - align_format_unit_test
 - bcftools
 - bdbloader_unit_test
 - bl2seq_unit_test
 - blast_format_unit_test
 - blast_formatter
 - blast_services_unit_test
 - blast_unit_test
 - blastdb_aliastool
 - blastdb_format_unit_test
 - blastdbcheck
 - blastdbcmd
 - blastdbcp
 - blastdiag_unit_test
 - blastengine_unit_test
 - blastextend_unit_test
 - blastfilter_unit_test
 - blasthits_unit_test
 - blastinput_unit_test
 - blastn
 - blastoptions_unit_test
 - blastp
 - blastsetup_unit_test
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
 - color-chrs.pl
 - convert2blastmask
 - createfontdatachunk.py
 - datatool
 - delta_unit_test
 - deltablast
 - dustmasker
 - ectyper
 - enhancer.py
 - explode.py
 - gapinfo_unit_test
 - gencode_singleton_unit_test
 - gene_info_reader
 - gene_info_unit_test
 - gifmaker.py
 - guess-ploidy.py
 - hspfilter_besthit_unit_test
 - hspfilter_culling_unit_test
 - hspstream_unit_test
 - idle3.5
 - ksu
 - legacy_blast.pl
 - linkhsp_unit_test
 - magicblast_unit_test
 - makeblastdb
 - makembindex
 - makeprofiledb
 - mash
 - msa2pssm_unit_test
 - ntlookup_unit_test
 - ntscan_unit_test
 - optionshandle_unit_test
 - painter.py
 - perl5.22.0
 - phiblast_unit_test
 - pilconvert.py
 - pildriver.py
 - pilfile.py
 - pilfont.py
 - pilprint.py
 - player.py
 - plot-roh.py
 - plot-vcfstats
 - prelimsearch_unit_test
 - project_tree_builder
 - psibl2seq_unit_test
 - psiblast
 - psiblast_iteration_unit_test
 - psiblast_unit_test
 - pssmcreate_unit_test
 - pssmenginefreqratios_unit_test
 - python3.5-config
 - python3.5m-config
 - pyvenv-3.5
 - querydata_unit_test
 - queryinfo_unit_test
 - redoalignment_unit_test
 - remote_blast_unit_test
 - rps_unit_test
 - rpsblast
 - rpstblastn
 - run-roh.pl
 - run_with_lock
 - sample
 - samtools
 - scoreblk_unit_test
 - search_strategy_unit_test
 - seedtop
 - segmasker
 - seqdb_demo
 - seqdb_perf
 - seqdb_unit_test
 - seqinfosrc_unit_test
 - seqsrc_unit_test
 - seqtk
 - setupfactory_unit_test
 - split_query_unit_test
 - stat_unit_test
 - subj_ranges_unit_test
 - tblastn
 - tblastx
 - test_pcre
 - thresholder.py
 - traceback_unit_test
 - tracebacksearch_unit_test
 - uniform_search_unit_test
 - update_blastdb.pl
 - vcfutils.pl
 - version_reference_unit_test
 - viewer.py
 - windowmasker
 - windowmasker_2.2.22_adapter.py
 - writedb_unit_test

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
whatis("Version: ctr-0.1--py35_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ectyper package")
whatis("URL: https://quay.io/repository/biocontainers/ectyper")

set_shell_function("aalookup_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg aalookup_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg aalookup_unit_test $*')
set_shell_function("aascan_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg aascan_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg aascan_unit_test $*')
set_shell_function("align_format_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg align_format_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg align_format_unit_test $*')
set_shell_function("bcftools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bcftools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bcftools $*')
set_shell_function("bdbloader_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bdbloader_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bdbloader_unit_test $*')
set_shell_function("bl2seq_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bl2seq_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bl2seq_unit_test $*')
set_shell_function("blast_format_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blast_format_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blast_format_unit_test $*')
set_shell_function("blast_formatter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blast_formatter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blast_formatter $*')
set_shell_function("blast_services_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blast_services_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blast_services_unit_test $*')
set_shell_function("blast_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blast_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blast_unit_test $*')
set_shell_function("blastdb_aliastool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdb_aliastool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdb_aliastool $*')
set_shell_function("blastdb_format_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdb_format_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdb_format_unit_test $*')
set_shell_function("blastdbcheck",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdbcheck $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdbcheck $*')
set_shell_function("blastdbcmd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdbcmd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdbcmd $*')
set_shell_function("blastdbcp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdbcp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdbcp $*')
set_shell_function("blastdiag_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdiag_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastdiag_unit_test $*')
set_shell_function("blastengine_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastengine_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastengine_unit_test $*')
set_shell_function("blastextend_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastextend_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastextend_unit_test $*')
set_shell_function("blastfilter_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastfilter_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastfilter_unit_test $*')
set_shell_function("blasthits_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blasthits_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blasthits_unit_test $*')
set_shell_function("blastinput_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastinput_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastinput_unit_test $*')
set_shell_function("blastn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastn $*')
set_shell_function("blastoptions_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastoptions_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastoptions_unit_test $*')
set_shell_function("blastp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastp $*')
set_shell_function("blastsetup_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastsetup_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastsetup_unit_test $*')
set_shell_function("blastx",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastx $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg blastx $*')
set_shell_function("bowtie2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2 $*')
set_shell_function("bowtie2-align-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-align-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-align-l $*')
set_shell_function("bowtie2-align-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-align-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-align-s $*')
set_shell_function("bowtie2-build",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-build $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-build $*')
set_shell_function("bowtie2-build-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-build-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-build-l $*')
set_shell_function("bowtie2-build-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-build-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-build-s $*')
set_shell_function("bowtie2-inspect",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-inspect $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-inspect $*')
set_shell_function("bowtie2-inspect-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-inspect-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-inspect-l $*')
set_shell_function("bowtie2-inspect-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-inspect-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg bowtie2-inspect-s $*')
set_shell_function("color-chrs.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg color-chrs.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg color-chrs.pl $*')
set_shell_function("convert2blastmask",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg convert2blastmask $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg convert2blastmask $*')
set_shell_function("createfontdatachunk.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg createfontdatachunk.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg createfontdatachunk.py $*')
set_shell_function("datatool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg datatool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg datatool $*')
set_shell_function("delta_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg delta_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg delta_unit_test $*')
set_shell_function("deltablast",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg deltablast $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg deltablast $*')
set_shell_function("dustmasker",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg dustmasker $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg dustmasker $*')
set_shell_function("ectyper",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg ectyper $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg ectyper $*')
set_shell_function("enhancer.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg enhancer.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg enhancer.py $*')
set_shell_function("explode.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg explode.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg explode.py $*')
set_shell_function("gapinfo_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg gapinfo_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg gapinfo_unit_test $*')
set_shell_function("gencode_singleton_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg gencode_singleton_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg gencode_singleton_unit_test $*')
set_shell_function("gene_info_reader",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg gene_info_reader $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg gene_info_reader $*')
set_shell_function("gene_info_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg gene_info_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg gene_info_unit_test $*')
set_shell_function("gifmaker.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg gifmaker.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg gifmaker.py $*')
set_shell_function("guess-ploidy.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg guess-ploidy.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg guess-ploidy.py $*')
set_shell_function("hspfilter_besthit_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg hspfilter_besthit_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg hspfilter_besthit_unit_test $*')
set_shell_function("hspfilter_culling_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg hspfilter_culling_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg hspfilter_culling_unit_test $*')
set_shell_function("hspstream_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg hspstream_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg hspstream_unit_test $*')
set_shell_function("idle3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg idle3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg idle3.5 $*')
set_shell_function("ksu",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg ksu $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg ksu $*')
set_shell_function("legacy_blast.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg legacy_blast.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg legacy_blast.pl $*')
set_shell_function("linkhsp_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg linkhsp_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg linkhsp_unit_test $*')
set_shell_function("magicblast_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg magicblast_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg magicblast_unit_test $*')
set_shell_function("makeblastdb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg makeblastdb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg makeblastdb $*')
set_shell_function("makembindex",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg makembindex $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg makembindex $*')
set_shell_function("makeprofiledb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg makeprofiledb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg makeprofiledb $*')
set_shell_function("mash",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg mash $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg mash $*')
set_shell_function("msa2pssm_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg msa2pssm_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg msa2pssm_unit_test $*')
set_shell_function("ntlookup_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg ntlookup_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg ntlookup_unit_test $*')
set_shell_function("ntscan_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg ntscan_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg ntscan_unit_test $*')
set_shell_function("optionshandle_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg optionshandle_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg optionshandle_unit_test $*')
set_shell_function("painter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg painter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg painter.py $*')
set_shell_function("perl5.22.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg perl5.22.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg perl5.22.0 $*')
set_shell_function("phiblast_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg phiblast_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg phiblast_unit_test $*')
set_shell_function("pilconvert.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pilconvert.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pilconvert.py $*')
set_shell_function("pildriver.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pildriver.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pildriver.py $*')
set_shell_function("pilfile.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pilfile.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pilfile.py $*')
set_shell_function("pilfont.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pilfont.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pilfont.py $*')
set_shell_function("pilprint.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pilprint.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pilprint.py $*')
set_shell_function("player.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg player.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg player.py $*')
set_shell_function("plot-roh.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg plot-roh.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg plot-roh.py $*')
set_shell_function("plot-vcfstats",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg plot-vcfstats $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg plot-vcfstats $*')
set_shell_function("prelimsearch_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg prelimsearch_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg prelimsearch_unit_test $*')
set_shell_function("project_tree_builder",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg project_tree_builder $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg project_tree_builder $*')
set_shell_function("psibl2seq_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg psibl2seq_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg psibl2seq_unit_test $*')
set_shell_function("psiblast",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg psiblast $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg psiblast $*')
set_shell_function("psiblast_iteration_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg psiblast_iteration_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg psiblast_iteration_unit_test $*')
set_shell_function("psiblast_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg psiblast_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg psiblast_unit_test $*')
set_shell_function("pssmcreate_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pssmcreate_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pssmcreate_unit_test $*')
set_shell_function("pssmenginefreqratios_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pssmenginefreqratios_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pssmenginefreqratios_unit_test $*')
set_shell_function("python3.5-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg python3.5-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg python3.5-config $*')
set_shell_function("python3.5m-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg python3.5m-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg python3.5m-config $*')
set_shell_function("pyvenv-3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pyvenv-3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg pyvenv-3.5 $*')
set_shell_function("querydata_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg querydata_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg querydata_unit_test $*')
set_shell_function("queryinfo_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg queryinfo_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg queryinfo_unit_test $*')
set_shell_function("redoalignment_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg redoalignment_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg redoalignment_unit_test $*')
set_shell_function("remote_blast_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg remote_blast_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg remote_blast_unit_test $*')
set_shell_function("rps_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg rps_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg rps_unit_test $*')
set_shell_function("rpsblast",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg rpsblast $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg rpsblast $*')
set_shell_function("rpstblastn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg rpstblastn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg rpstblastn $*')
set_shell_function("run-roh.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg run-roh.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg run-roh.pl $*')
set_shell_function("run_with_lock",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg run_with_lock $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg run_with_lock $*')
set_shell_function("sample",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg sample $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg sample $*')
set_shell_function("samtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg samtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg samtools $*')
set_shell_function("scoreblk_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg scoreblk_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg scoreblk_unit_test $*')
set_shell_function("search_strategy_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg search_strategy_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg search_strategy_unit_test $*')
set_shell_function("seedtop",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seedtop $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seedtop $*')
set_shell_function("segmasker",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg segmasker $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg segmasker $*')
set_shell_function("seqdb_demo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqdb_demo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqdb_demo $*')
set_shell_function("seqdb_perf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqdb_perf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqdb_perf $*')
set_shell_function("seqdb_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqdb_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqdb_unit_test $*')
set_shell_function("seqinfosrc_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqinfosrc_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqinfosrc_unit_test $*')
set_shell_function("seqsrc_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqsrc_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqsrc_unit_test $*')
set_shell_function("seqtk",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqtk $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg seqtk $*')
set_shell_function("setupfactory_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg setupfactory_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg setupfactory_unit_test $*')
set_shell_function("split_query_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg split_query_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg split_query_unit_test $*')
set_shell_function("stat_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg stat_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg stat_unit_test $*')
set_shell_function("subj_ranges_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg subj_ranges_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg subj_ranges_unit_test $*')
set_shell_function("tblastn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg tblastn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg tblastn $*')
set_shell_function("tblastx",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg tblastx $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg tblastx $*')
set_shell_function("test_pcre",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg test_pcre $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg test_pcre $*')
set_shell_function("thresholder.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg thresholder.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg thresholder.py $*')
set_shell_function("traceback_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg traceback_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg traceback_unit_test $*')
set_shell_function("tracebacksearch_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg tracebacksearch_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg tracebacksearch_unit_test $*')
set_shell_function("uniform_search_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg uniform_search_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg uniform_search_unit_test $*')
set_shell_function("update_blastdb.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg update_blastdb.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg update_blastdb.pl $*')
set_shell_function("vcfutils.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg vcfutils.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg vcfutils.pl $*')
set_shell_function("version_reference_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg version_reference_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg version_reference_unit_test $*')
set_shell_function("viewer.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg viewer.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg viewer.py $*')
set_shell_function("windowmasker",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg windowmasker $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg windowmasker $*')
set_shell_function("windowmasker_2.2.22_adapter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg windowmasker_2.2.22_adapter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg windowmasker_2.2.22_adapter.py $*')
set_shell_function("writedb_unit_test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg writedb_unit_test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ectyper/ectyper-0.1--py35_0.simg writedb_unit_test $*')
