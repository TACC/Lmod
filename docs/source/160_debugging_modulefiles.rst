.. _debugging_modulefiles_label:

Debugging Modulefiles
=====================

This topic is under construction

#. Use ``$LMOD_CMD bash load <module_file>``  to show what the text that
   Lmod is generating.
#. Add print() statements with the warning that they will need to be
   removed when module is evaluated.
#. To track local variable behavior inside a module file add
   ``io.stderr:write("var: ",var,"\n)`` to know the value of a
   variable.
