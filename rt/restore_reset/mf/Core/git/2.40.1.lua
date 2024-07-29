--[[ File for git

  Built as:
 
    ./configure --prefix=/ford1/share/gmao_SIteam/git/git-2.40.1 |& tee configure.log
 
  Then:
    make -j4 all |& tee make.log
    make install |& tee makeinstall.log
 
  To get the man pages, download the:
 
   git-manpages-2.40.1.tar.xz
 
  tarball from:
 
   https://mirrors.edge.kernel.org/pub/software/scm/git/
 
  and then do:
 
   mkdir -p /ford1/share/gmao_SIteam/git/git-2.40.1/share/man
   tar xf git-manpages-2.40.1.tar.xz -C /ford1/share/gmao_SIteam/git/git-2.40.1/share/man/

--]]

local version = "git-2.40.1"
local installdir = "/ford1/share/gmao_SIteam/git"

local pkgdir = pathJoin(installdir,version)

prepend_path("PATH",pathJoin(pkgdir,"bin"))
prepend_path("MANPATH",pathJoin(pkgdir,"share/man"))
