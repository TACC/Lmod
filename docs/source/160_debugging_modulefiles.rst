.. _debugging_modulefiles_label:

Debugging Modulefiles
=====================

This topic is under construction

#. Use ``$LMOD_CMD bash load <module_file>``  to show what the text that
   Lmod is generating.
#. To track local variable behavior inside a module file add
   ``io.stderr:write("var: ",var,"\n)`` to know the value of a
   variable.
