.. _deepdive_markdown:

Markdown Detection and Processing in Help and Whatis
====================================================

When users run ``module help <name>`` or ``module whatis <name>``, Lmod
displays content from the modulefile's ``help()`` and ``whatis()`` calls.
This content may be formatted as markdown. Two components handle this:

1. **MarkdownDetector** determines whether the content appears to be markdown.
2. **MarkdownProcessor** converts markdown to terminal-friendly ANSI output.

Data Flow
---------

*   **Entry points**: ``src/MC_Access.lua`` handles ``module help``; ``src/MC_Show.lua``
    handles ``module show`` and the whatis portion of module display. Both obtain
    the raw string content from the modulefile (via the sandbox evaluation of
    ``help()`` and ``whatis()``).

*   **Detection**: Before displaying, the content is passed to
    ``MarkdownDetector.isMarkdown(content)``. If it returns ``true``, the content
    is treated as markdown.

*   **Processing**: When content is detected as markdown, it is passed to
    ``MarkdownProcessor.toTerminal(content)``, which converts markdown elements
    to ANSI-formatted text. When not markdown, the content is shown as plain text.
    For ``toPlainText()`` (used when stripping formatting), images are rendered
    as ``[Image: alt] (url)``.

*   **Output**: The resulting string is appended to the output buffer and
    eventually printed to the user's terminal (or stderr during ``module show``).

Key Files
---------

*   ``src/MarkdownDetector.lua``: Heuristic detection logic.
*   ``src/MarkdownProcessor.lua``: Conversion of markdown to terminal output.
*   ``src/MC_Access.lua``: Calls detector and processor for ``help()`` content.
*   ``src/MC_Show.lua``: Calls detector and processor for ``show`` and whatis.

MarkdownDetector
----------------

The detector uses heuristic scoring to decide if content is markdown. It is
designed to avoid false positives (e.g., formatting environment variable
lists or technical output as markdown).

**Line Splitting**

Content is split into lines using a ``splitLines()`` helper that relies on
``string.find()`` rather than ``string.gmatch()``. This gives consistent
behavior across Lua 5.1–5.4; see ``LUA_GMATCH_BEHAVIOR.md`` in the project
root for the rationale.

**Indicators and Scoring**

The detector counts the following indicators:

*   **atx_headers**: Lines matching ``^#+%s+%S`` (e.g., ``# Header``).
*   **setext_headers**: Underlines ``^===+$`` or ``^---+$`` with a non-empty
    line above.
*   **lists**: Lines matching ``^[-*+]%s+%S`` or ``^%d+\.%s+%S`` with 0–3
    spaces of indentation. Heavier indentation is ignored to reduce false
    positives.
*   **emphasis**: ``**bold**``, ``*italic*``, ``__bold__``, ``_italic_``.
*   **code**: Inline (single backticks) and fenced (triple backticks) blocks.
*   **links**: ``[text](url)``.
*   **images**: ``![alt](url)``.
*   **structure**: Paragraph structure (empty lines, long lines) when other
    markdown indicators are present.

Each indicator contributes to a score. Content is marked as markdown if the
score is **≥ 3**. The threshold and scoring logic are in
``MarkdownDetector.isMarkdown()``.

**False Positive Prevention**

*   Content shorter than 30 characters is never treated as markdown.
*   List detection is limited to 0–3 spaces of indentation.
*   Structure contributes only when other markdown indicators exist.
*   Setext underlines must have a non-empty line immediately above (possibly
    with blank lines in between).

MarkdownProcessor
-----------------

The processor walks the content line by line and converts markdown to ANSI
output.

**Processing Order**

1.  Code blocks (triple backticks) are handled first; lines inside are output with
    dim/cyan styling.
2.  Setext headers are detected by checking if the next line is an underline;
    the header text is formatted (bold/cyan for ``=``, bold for ``-``).
3.  ATX headers are stripped of ``#`` and formatted by level.
4.  List items (``-``, ``*``, ``+``, ``1.``) are prefixed with bullets or
    numbers and support inline formatting.
5.  Inline elements (code, emphasis, images, links) are processed within
    paragraph and list content.

**ANSI and Color**

Colors are used when ``supportsColor()`` returns true (e.g., ``TERM`` contains
``xterm`` or ``color``, or ``LMOD_COLORIZE=yes``). During regression testing
(``optionTbl().rt == true``), color is disabled so tests are reproducible.
ANSI codes are defined in the ``ANSI`` table in ``MarkdownProcessor.lua``.

**Images**

Image syntax ``![alt](url)`` is rendered as ``[Image: alt] (url)`` in cyan,
since terminals cannot display images. Processing runs before link processing
to avoid conflicts.

Regression Tests
----------------

The markdown feature is exercised in ``rt/markdown/``. Tests cover detection
(both positive and false-positive cases), processing of various elements, and
behavior of ``help``, ``show``, and ``whatis``. See ``rt/markdown/markdown.tdesc``
and ``LMOD_TESTING.md`` for how to run them.
