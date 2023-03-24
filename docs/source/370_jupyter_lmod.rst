Jupyter and Lmod
================

It is possible to use Lmod inside of Jupyter with the terminal or jupyter-lmod.

jupyter-lmod is a frontend and server extension for Jupyter (notebook and jupyterlab).
The extension provides most of Lmod functionalities graphically:
    - Browser and filter available modules
    - Load and unload modules
    - Display a module content
    - Create and load collections

Installation
~~~~~~~~~~~~

To install jupyter-lmod extension: ::

    pip install jupyterlmod

This enables the extension for both Jupyter Notebook and JupyterLab.

How does it work?
~~~~~~~~~~~~~~~~~

jupyter-lmod uses lmod python interface to generate Python code
that modifies the environment variables of the Python process running Jupyter. All child
processes of Jupyter (including kernels) created after Lmod calls inherit
the environment variables as defined by the set of loaded modules.

Lmod environment variable configuration for jupyter-lmod
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The plugin requires the environment variable **$LMOD_CMD** to be defined when Jupyter starts,
plus all environment variables required by Lmod to work properly (i.e.: **$MODULEPATH**).

Some JupyterHub spawners do not setup the complete user's environment, leaving **$LMOD_CMD**
and **$MODULEPATH** undefined. To address this issue, the environment variables have to be
defined in **jupyterhub_config.py** using
`c.Spawner.environment <https://jupyterhub.readthedocs.io/en/stable/api/spawner.html#jupyterhub.spawner.Spawner.environment>`_.

If the environment variables are defined before JupyterHub launch, you can add their
name only to `c.Spawner.env_keep <https://jupyterhub.readthedocs.io/en/stable/api/spawner.html#jupyterhub.spawner.Spawner.env_keep>`_
instead.

References
~~~~~~~~~~

For more information, refer to jupyter-lmod github repo:
https://www.github.com/cmd-ntrf/jupyter-lmod

