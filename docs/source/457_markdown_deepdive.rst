.. _deepdive_markdown:

Markdown Detection and Processing in Help and Whatis
====================================================

When you run ``module help <name>`` or ``module whatis <name>``, Lmod gets
the raw string from the modulefile's ``help()`` or ``whatis()`` (via the
sandbox). Two pieces handle markdown: **MarkdownDetector** decides if the
content looks like markdown, and **MarkdownProcessor** converts it to ANSI
output for the terminal.

Flow
----

``src/MC_Access.lua`` handles ``module help``; ``src/MC_Show.lua`` handles
``module show`` and the whatis portion of module display. Both get the
string from the modulefile and pass it to ``MarkdownDetector.isMarkdown()``.
If that returns true, the content goes to ``MarkdownProcessor.toTerminal()``.
The result is appended to the output buffer and printed. If it's not
markdown, the content is shown as plain text. For ``toPlainText()`` (used
when stripping formatting), images become ``[Image: alt] (url)``.

Key files: ``src/MarkdownDetector.lua`` (detection), ``src/MarkdownProcessor.lua``
(conversion), ``src/MC_Access.lua``, ``src/MC_Show.lua``.

MarkdownDetector
----------------

The detector scores the content. Things like headers, lists, emphasis, code
blocks, and links add points. If the score reaches 3 or more, the content
is treated as markdown. This avoids formatting plain text (e.g., env var
dumps) as markdown.

**Line splitting:** Content is split into lines with ``splitLines()``, which
uses ``string.find()`` instead of ``string.gmatch()``. Lua's ``gmatch()``
behaves differently across 5.1–5.4 for some patterns; ``find()`` gives
consistent behavior.

**Indicators:** atx_headers (``^#+%s+%S``), setext_headers (``^===+$`` or
``^---+$`` with a non-empty line above), lists (``^[-*+]%s+%S`` or
``^%d+\.%s+%S`` with 0–3 spaces), emphasis, code, links, images, structure.
Heavier list indentation is ignored. Content under 30 characters is never
markdown. Setext underlines must have a non-empty line above.

MarkdownProcessor
-----------------

The processor goes through the content line by line and converts markdown
to ANSI.

**Order:** Code blocks first (dim/cyan), then setext headers, ATX headers,
list items, then inline elements (code, emphasis, images, links) within
paragraphs and lists.

**Color:** Used when ``supportsColor()`` returns true (``TERM`` has
``xterm`` or ``color``, or ``LMOD_COLORIZE=yes``). Disabled during
regression tests (``optionTbl().rt == true``). Codes live in the ``ANSI``
table in ``MarkdownProcessor.lua``.

**Images:** ``![alt](url)`` becomes ``[Image: alt] (url)`` in cyan.
Processed before links to avoid conflicts.

Regression tests
----------------

See :ref:`lmod_testing_guide` for how to run the markdown tests.
