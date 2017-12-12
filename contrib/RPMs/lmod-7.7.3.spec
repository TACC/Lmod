Prefix:    /opt/apps
Summary:   lmod: Lua based Modules
Name:      lmod
Version:   7.7.3
Release:   1%{?dist}
License:   MIT
Vendor:    Robert McLay
Group:     System Environment/Base
Source:    Lmod-%{version}.tar.bz2
Packager:  TACC - mclay@tacc.utexas.edu
Buildroot: /var/tmp/%{name}-%{version}-buildroot

%define debug_package %{nil}
%include rpm-dir.inc

%define pkg_base_name lmod
%define name_prefix   tacc
%define pkg_name      %{name_prefix}-%{pkg_base_name}


%define APPS           /opt/apps
%define PKG_BASE       /opt/apps/%{pkg_base_name}
%define INSTALL_DIR    %{PKG_BASE}/%{version}
%define GENERIC_IDIR   %{PKG_BASE}/lmod
%define MODULES        modulefiles
%define MODULE_DIR     %{APPS}/%{MODULES}/lmod
%define MODULE_DIR_ST  %{APPS}/%{MODULES}/settarg
%define ZSH_SITE_FUNC  /usr/share/zsh/site-functions

%package -n %{pkg_name}
Summary: lmod: Lua based Modules
Group: System
%description
%description -n %{pkg_name}

Lua Based Modules

%prep
rm -rf $RPM_BUILD_ROOT/%{INSTALL_DIR} $RPM_BUILD_ROOT/%{ZSH_SITE_FUNC}

##
## SETUP
##

%setup -n Lmod-%{version}

##
## BUILD
##

%build

%install

myhost=$(hostname -f)
myhost=${myhost%.tacc.utexas.edu}
first=${myhost%%.*}
SYSHOST=${myhost#*.}

CACHE_DIR="--with-spiderCacheDescript=cacheDescript.txt"

cat > cacheDescript.txt << EOF
/tmp/moduleData/cacheDir:/tmp/losf_last_update
EOF
  
if [ "$SYSHOST" = "ls5" ]; then
   EXTRA="--with-tmodPathRule=yes"
fi

# Lmod needs lua but should not require that a working module
# system be in place to install lmod.  So we search for lua
# the old fashion way

for i in /usr/bin /opt/apps/lua/lua/bin /usr/local/bin /opt/local/bin ; do
  if [ -x $i/lua ]; then
    luaPath=$i
    break
  fi
done
PATH=$luaPath:$PATH

mkdir -p $RPM_BUILD_ROOT/%{INSTALL_DIR} $RPM_BUILD_ROOT/%{ZSH_SITE_FUNC}

./configure --prefix=%{APPS} $CACHE_DIR --with-settarg=FULL $EXTRA --with-siteName=TACC 
make DESTDIR=$RPM_BUILD_ROOT install
cp contrib/TACC/*.lua $RPM_BUILD_ROOT/%{INSTALL_DIR}/libexec

rm $RPM_BUILD_ROOT/%{INSTALL_DIR}/../lmod

#-----------------
# Modules Section
#-----------------

rm -rf $RPM_BUILD_ROOT/%{MODULE_DIR}
mkdir -p $RPM_BUILD_ROOT/%{MODULE_DIR}
cat   >  $RPM_BUILD_ROOT/%{MODULE_DIR}/%{version}.lua << 'EOF'
-- -*- lua -*-
help(
[[
This module is for Lmod.  Normal user will probably not need to
load this module.  It is only required if one is using the tools
that are part of Lmod.

Version %{version}
]])

local version = "%{version}"
whatis("Name: Lmod")
whatis("Version: " .. version)
whatis("Category: System Software")
whatis("Keywords: System, Utility, Tools")
whatis("Description: An environment module system")
whatis("URL: http://www.tacc.utexas.edu/tacc-projects/lmod")

prepend_path( "PATH",            "%{GENERIC_IDIR}/libexec" )
EOF

#--------------
#  Version file.
#--------------

cat > $RPM_BUILD_ROOT/%{MODULE_DIR}/.version.%{version} << 'EOF'
#%Module3.1.1#################################################
##
## version file for %{pkg_base_name}-%{version}
##

set     ModulesVersion      "%{version}"
EOF

rm -rf $RPM_BUILD_ROOT/%{MODULE_DIR_ST}
mkdir -p $RPM_BUILD_ROOT/%{MODULE_DIR_ST}
sed -e "s|@PKG@|%{GENERIC_IDIR}|g"     \
    -e "s|@settarg_cmd@|settarg_cmd|g" \
    -e "s|@path_to_lua@|$luaPath|g"    \
    < MF/settarg.version.lua > $RPM_BUILD_ROOT/%{MODULE_DIR_ST}/%{version}.lua     

#--------------
#  Version file.
#--------------

cat > $RPM_BUILD_ROOT/%{MODULE_DIR_ST}/.version.%{version} << 'EOF'
#%Module3.1.1#################################################
##
## version file for %{name}-%{version}
##

set     ModulesVersion      "%{version}"
EOF

%files -n %{pkg_name}
%defattr(-,root,root,)
%{INSTALL_DIR}
%{MODULE_DIR}
%{MODULE_DIR_ST}
%{ZSH_SITE_FUNC}/_ml
%{ZSH_SITE_FUNC}/_module

%post -n %{pkg_name}

cd %{PKG_BASE}

if [ -d %{pkg_base_name} ]; then
  rm -f %{pkg_base_name}
fi
ln -s %{version} %{pkg_base_name}

%postun -n %{pkg_name}

cd %{PKG_BASE}

if [ -h %{pkg_base_name} ]; then
  lv=`readlink %{pkg_base_name}`
  if [ ! -d $lv ]; then
    rm %{pkg_base_name}
  fi
fi

%clean -n %{pkg_name}
rm -rf $RPM_BUILD_ROOT
