Load Storms: Long load times or Fails to Load
==============================================

Sometimes it can take a long time for a module to load.  Or Lmod will
produce an error that it can't load a module it should.  One likely
possibility is that you have a ``load storm``.  That is Lmod is
loading and reloading the same modulefiles over and over.   This can
happen when a module tries to load other modules and other modules do
the same.  For example A/1.0.lua is::


    load("B/2.0")
    load("C/2.0")

The module B/2.0.lua is::

    load("C/2.0")
    load("D/2.0")

And module C/2.0.lua is::

   load("D/2.0")


The load() function always loads the requested module file even if
that modulefile is already loaded.

Lmod can report what is happening.  Using the -D debug flag it is
possible to track what gets loaded::

   $ module purge
   $ module -D load A          2> ~/load_storm.log
   $ grep 'MasterControl:.*load(' ~/load_storm.log

The results from the grep is::

  MasterControl:load(mA={A}){
      MasterControl:load(mA={B/2.0}){
          MasterControl:load(mA={C/2.0}){
              MasterControl:load(mA={D/2.0}){
          MasterControl:load(mA={D/2.0}){
              MasterControl:unload(mA={D}){
              MasterControl:load(mA={D/2.0}){
      MasterControl:load(mA={C/2.0}){
          MasterControl:unload(mA={C}){
              MasterControl:unload(mA={D/2.0}){
          MasterControl:load(mA={C/2.0}){
              MasterControl:load(mA={D/2.0})

We can see that the ``D/2.0.lua`` module is loaded 4 times in this
example.   To avoid this problem, one can reduce the number of loads.
In this case, the B/2.0.lua module can only load the C module as D is
already being loaded by the C module.  If this is not practical then
placing guards around the load statement can also reduce the number of
loads.  For example changing A/1.0.lua to::

    if (not isloaded("B/2.0")) then
       load("B/2.0")
    end
    if (not isloaded("C/2.0")) then
       load("C/2.0")
    end

and similarly for the other modules will reduce loading of each module
to one time.  This can been seen by executing the debug module load
and greping the results as before::

      MasterControl:load(mA={A}){
         MasterControl:load(mA={B/2.0}){
            MasterControl:load(mA={C/2.0}){
               MasterControl:load(mA={D/2.0}){

The above guard statements won't unload the dependent module,
unloading the A won't unload B, C, or D.  Changing the guard
statements to the following will allow for loading and unloading::

    if (not isloaded("B/2.0") or mode() == "unload") then
       load("B/2.0")
    end
    if (not isloaded("C/2.0") or mode() == "unload") then
       load("C/2.0")
    end
