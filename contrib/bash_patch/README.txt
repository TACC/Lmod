The patch file contained in this directory is the patch we use to
force our bash to read a system bashrc on interactive shells.  We
make our shells read /etc/tacc/profile and /etc/tacc/bashrc instead
of /etc/profile and /etc/bashrc.  This way we control what goes
into these start-up files and not our Linux distribution.

Please modify this patch file to suit your sites needs and rebuild
bash.

