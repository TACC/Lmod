.. _localization:

Lmod Localization
=================

Lmod places all messages, warning and error messages into a file.  It
also uses a slightly modified version of the i18n package from:

   https://github.com/kikito/i18n.lua

to allow for translate into multiple languages.  The standard message
file is in messageDir/en.lua.  Other languages are such as French,
Spanish, German, and Mandarin Chinese are available.  You can submit
pull requests if you wish to have other languages.  Lmod uses the LANG
variable to pick which language to use.  Note that Lmod only uses the
first part of the LANG variable to choose which language to use.  So
there is only one version of English and one version of Spanish and so
on. So a typical value of LANG is:

   LANG=en_US.UTF-8

Lmod removes from the underscore on and just uses "en".   A site can
also configure Lmod or set LMOD_LANG to override $LANG.

Site Tailoring
~~~~~~~~~~~~~~

It is also possible to modify the standard messages to be tailored for
a site. You can leave the Language to be English but change the value
of a particular message to better match your site.  For example you
might change message e118 (as seen in messageDir/en.lua).  Please note that
the message string should be on one line.::

     e118 = "User module collection: \\"%{collection}\\" does not exist.\\n  Try \\"module savelist\\" for possible choices.\\n",


by creating a file called: /path/to/site_msgs.lua::

     return {
          site = {
              e118 = "User module collection: \\"%{collection}\\" does not exist.\\n  Try \\"module savelist\\" for possible choices.  For questions see https://...\\n";,
          }
      }

Then configure Lmod (or set env var. LMOD_SITE_MSG_FILE) to use
/path/to/site_msg.lua.
