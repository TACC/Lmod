.. _markdown_help-label:

Markdown in Module Help and Whatis
==================================

Lmod automatically detects and formats markdown in the content passed to
``help()`` and ``whatis()``. When users run ``module help <name>`` or
``module whatis <name>``, formatted help text is displayed in the terminal.
There is no configuration toggle: detection and processing are always active
when displaying help and whatis content.

Overview
--------

The markdown feature works in two stages:

1. **Detection**: Lmod analyzes the content to determine whether it appears to
   be written in markdown. Detection uses heuristic scoring to avoid
   formatting plain text (e.g., environment variable lists or technical
   output) as markdown.

2. **Processing**: If content is detected as markdown, Lmod converts it to
   terminal-friendly output using ANSI formatting (bold, italic, colors)
   when the terminal supports it. During regression testing, colors are
   disabled.

Supported Markdown Elements
---------------------------

The following markdown syntax is recognized and formatted:

* **Headers** — ATX style (``#``, ``##``, ``###``) and Setext style (underline
  with ``===`` or ``---``)
* **Lists** — Unordered (``-``, ``*``, ``+``) and ordered (``1.``, ``2.``)
  with up to 3 spaces of indentation
* **Emphasis** — Bold (``*text*``, ``**text**``, ``__text__``) and italic
  (``*text*`` or ``_text_``)
* **Inline code** — Single backticks around text
* **Code blocks** — Triple backticks (fenced blocks)
* **Links** — ``[text](url)``
* **Images** — ``![alt](url)``, displayed as ``[Image: alt] (url)`` in the
  terminal

Example
-------

The following modulefile uses markdown in its ``help()`` string to produce
formatted output when users run ``module help scientific_computing/2.0``::

    help([[
    # Scientific Computing Suite

    ## Description
    This module provides a comprehensive suite of **scientific computing tools**
    for *high-performance computing* workloads. Optimized libraries and
    development tools for numerical computing are included.

    ## Features
    - Optimized `BLAS` and `LAPACK` libraries
    - **MPI** support for parallel computing
    - GPU acceleration with `CUDA` and `OpenCL`
    - Advanced profiling and debugging tools

    ## Quick Start
    ```bash
    module load scientific_computing/2.0
    export OMP_NUM_THREADS=8
    ./run_simulation.sh
    ```

    ## Resources
    For more information, visit the [project website](https://docs.example.com/scicomp).
    See the [user guide](https://docs.example.com/guide.pdf) for detailed usage.

    ## Architecture
    ![Module Architecture Diagram](https://docs.example.com/arch.png)
    ![Dependency Graph](deps.png)

    ### Installation Notes
    1. Ensure `gcc/9.0` or later is loaded
    2. Verify **CUDA** drivers are installed
    3. Run `make test` to verify installation
    ]])

The rendered output in the terminal shows formatted headers, bullet lists,
code blocks, links, and image references. A visual example is available in
``markdown_demo.html``; open it in a browser to preview the output style, or
see the screenshot below.

.. figure:: _static/lammps_help_example.png
   :alt: LAMMPS module help rendered in a web interface with markdown formatting
   :width: 90%
   :align: center

   Example of formatted module help output (LAMMPS module) showing headers, the
   embedded logo, lists, code blocks, links, and emphasis.

Capabilities and Limitations
----------------------------

**Capabilities**

* Output is optimized for terminal display. When ``TERM`` indicates color
  support (e.g., ``xterm``, ``screen``) or ``LMOD_COLORIZE=yes``, ANSI codes
  are used for emphasis and structure.
* Inline formatting (bold, italic, code) works within list items.
* The parser is pure Lua with no external dependencies.

**Limitations**

* Content shorter than 30 characters is always treated as plain text.
* Only a subset of CommonMark is implemented. Tables, blockquotes, and
  footnotes are not supported.
* Images are rendered as ``[Image: alt text] (url)``; actual image display
  is not supported in the terminal.
* Heuristic detection may occasionally treat structured plain text as
  markdown or fail to detect marginal markdown. See :ref:`markdown_detection`
  for details.

.. _markdown_detection:

How Detection Works
-------------------

Lmod uses a heuristic scoring system to decide whether content is markdown.
Indicators (ATX headers, setext headers, lists, emphasis, code, links, images,
and paragraph structure) contribute to a score. Content is treated as
markdown if the score reaches **3 or higher**.

**Indicator scores**

* ATX headers (``#``): +3
* Setext headers (``===``, ``---``): +3
* Code blocks (triple backticks): +3
* Links: +2
* Images: +2
* Lists (more than one list item): +2
* Emphasis (``*bold*``, ``_italic_``): +1
* Structure (paragraphs plus other indicators): +1

Detection is conservative to avoid formatting plain text as markdown. For
example, list-like patterns with more than 3 spaces of indentation are
ignored, and structure alone does not increase the score unless other
markdown indicators are present.

Troubleshooting
---------------

**Content is displayed as plain text when I expect markdown**

* Ensure the content is at least 30 characters long.
* Add more markdown elements (e.g., headers, multiple list items, or
  emphasis) to raise the detection score.
* Check that list items use 0–3 spaces of indentation; heavier indentation
  may be treated as prose.

**Debugging detection**

Use Lmod's debug flag to inspect detection::

   % module -D help <moduleName> 2> debug.log

Search for ``MarkdownDetector`` in the log to see the detection score and
indicator breakdown when debugging why content is or is not detected as
markdown.

For implementation details, see :ref:`deepdive_markdown`.
