---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---

**Notes**
Please note that we do not provide patches to older versions of Lmod, To speed up fixing your issue please test your bug against the latest version of Lmod.
See: https://lmod.readthedocs.io/en/latest/045_transition.html if you want to install the latest version in your own account.


**Describe the bug**
A clear and concise description of what the bug is.  If it helps, please include a module tree that shows the issue.
 
**To Reproduce**
Steps to reproduce the behavior:

If you are having an issue with a moduletree that is using the hierarchy consider using the moduletree provided in the source repo: 
To use do the following:

 - copy bugReport directry tree to your own directory
 - modify as necessary the modules under the my_modules directory
 - modify the bug_report_template.sh script to show your issue
 - Run the script this way:

 $ env -i LMOD_ROOT=$LMOD_ROOT ./bug_report_template.sh

**Expected behavior**
A clear and concise description of what you expected to happen.

**Desktop (please complete the following information):**
 - OS: [Linux, macOS]
 - Linux distribution:
 - XALT Version:

**Additional context**
Add any other context about the problem here.
