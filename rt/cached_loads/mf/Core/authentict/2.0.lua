local help_message = [[
This is a module file for the container quay.io/biocontainers/authentict:1.0.1--py311h9f5acd7_0, which exposes the
following programs:
	eferlanti@tacc.utexas.edu
]]

help(help_message,"\n")

whatis("Name: authentict")
whatis("Version: ctr-1.0.1--py311h9f5acd7_0")
whatis("Category: Genotyping, Sequence contamination filtering, DNA substitution modelling")
whatis("Keywords: DNA, Mapping, Sequence sites, features and motifs, Sequencing")
whatis("Description: AuthentiCT is a command-line tool to estimate the proportion of present-day DNA contamination in ancient DNA datasets generated from single-stranded libraries. It estimates contamination using an ancient DNA damage model and assumes that the contaminant is not deaminated.")
whatis("URL: https://quay.io/repository/biocontainers/authentict")

local programs = {"2to3-3.11", "AuthentiCT", "ace2sam", "acountry", "acpid", "adig", "adjtimex", "ahost", "arp", "beep", "bgzip", "blast2sam.pl", "bootchartd", "bowtie2sam.pl", "brctl", "busybox", "chat", "chpst", "chvt", "compile_et", "conspy", "crond", "crontab", "cryptpw", "cttyhack", "curl-config", "deallocvt", "devmem", "dhcprelay", "dos2unix", "dumpkmap", "dumpleases", "ed", "envdir", "envuidgid", "ether-wake", "export2sam.pl", "f2py", "f2py3", "f2py3.11", "fakeidentd", "fasta-sanitize.pl", "fatattr", "fbset", "fbsplash", "fdflush", "fgconsole", "freeramdisk", "fsync", "ftpget", "ftpput", "fuser", "gss-client", "gss-server", "hd", "htsfile", "idle3", "idle3.11", "ifconfig", "ifdown", "ifplugd", "ifup", "inetd", "interpolate_sam.pl", "iostat", "ipaddr", "ipcalc", "iplink", "ipneigh", "iproute", "iprule", "iptunnel", "k5srvutil", "kadmin", "kadmin.local", "kadmind", "kbd_mode", "kdb5_util", "kdestroy", "key.dns_resolver", "keyctl", "killall", "kinit", "klist", "klogd", "kpasswd", "kprop", "kpropd", "kproplog", "krb5-config", "krb5-send-pr", "krb5kdc", "kswitch", "ktutil", "kvno", "libdeflate-gunzip", "libdeflate-gzip", "loadfont", "loadkmap", "logread", "lpd", "lpq", "lpr", "lsof", "lspci", "lsscsi", "lsusb", "lzmadec", "lzop", "makedevs", "makemime", "man", "maq2sam-long", "maq2sam-short", "md5fa", "md5sum-lite", "mdev", "microcom", "mkdosfs", "mkfs.vfat", "mkpasswd", "mpstat", "mt", "nameif", "nanddump", "nandwrite", "nbd-client", "nc", "ncurses6-config", "netstat", "nghttp", "nghttpd", "nghttpx", "nmeter", "normalizer", "novo2sam.pl", "nslookup", "ntpd", "nuke", "openvt", "partprobe", "pip3", "pipe_progress", "plot-ampliconstats", "plot-bamstats", "popmaildir", "powertop", "pscan", "psl2sam.pl", "pstree", "pydoc3", "pydoc3.11", "python3", "python3-config", "python3.1", "python3.11", "python3.11-config", "raidautorun", "rdate", "rdev", "readahead", "reformime", "request-key", "resize", "resume", "route", "run-init", "runsv", "runsvdir", "rx", "sam2vcf.pl", "samtools", "samtools.pl", "sclient", "sendmail", "seq_cache_populate.pl", "setconsole", "setfattr", "setfont", "setkeycodes", "setlogcons", "setserial", "setuidgid", "sha3sum", "showkey", "sim_client", "sim_server", "slattach", "smemcap", "soap2sam.pl", "softlimit", "sserver", "ssl_client", "sv", "svc", "svlogd", "svok", "syslogd", "tabix", "telnet", "telnetd", "tftp", "tftpd", "traceroute", "traceroute6", "ts", "ttysize", "tunctl", "ubiattach", "ubidetach", "ubimkvol", "ubirename", "ubirmvol", "ubirsvol", "ubiupdatevol", "udhcpc", "udhcpc6", "uevent", "unix2dos", "unzip", "usleep", "uuclient", "uudecode", "uuencode", "uuserver", "vconfig", "vlock", "volname", "watchdog", "wgsim", "wgsim_eval.pl", "whois", "x86_64-conda-linux-gnu-ld", "x86_64-conda_cos6-linux-gnu-ld", "xxd", "zcip", "zoom2sam.pl"}
local run_function = "apptainer exec ${BIOCONTAINER_DIR}/biocontainers/authentict/authentict-1.0.1--py311h9f5acd7_0.sif $RGC_APP"

-- Define shell functions
for i,program in pairs(programs) do
	set_shell_function(program,
		"RGC_APP=" .. program .. "; " .. run_function .. " $@",
		"RGC_APP=" .. program .. "; " .. run_function .. " $*")
end

-- Export functions on load
execute{cmd=[=[ [[ -n "${BASH_VERSION:-}" ]] &&  export -f ]=] .. table.concat(programs, " "), modeA={"load"}}
-- Unset functions on unload
execute{cmd="unset -f " .. table.concat(programs, " "), modeA={"unload"}}
