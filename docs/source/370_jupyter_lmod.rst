Jupyter and Lmod
================

- It is possible to use Lmod inside of Jupyter
    - using the terminal command-line
    - using jupyter-lmod

- jupyter-lmod is a plugin that integrates inside Jupyter Notebook and JupyterLab UI
and provides Lmod functionalities graphically
    - Filter available module through textfield
    - Load and unload modules with button
    - Display a module content
    - Create and load collections

- How does it work? jupyter-lmod uses lmod python interface to generate Python code
that modifies the environment variables of the Python process running Jupyter. All child
processes of Jupyter  (including kernels) created after the module function calls, inherits
the environment variables as defined by Lmod's modules.

- The plugin requires the export of the environment variable `LMOD_CMD` before the launch
of jupyter. If you are using JupyterHub, with some spawners (i.e.: LocalSpawner, SudoSpawner), 
you will have to add `LMOD_CMD` to `c.Spawner.env_keep` in `jupyterhub_config.py`

- For more information on how to install it, refer to jupyter-lmod github repo:
https://www.github.com/cmd-ntrf/jupyter-lmod

