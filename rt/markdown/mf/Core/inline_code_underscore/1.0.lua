-- IS861: underscores inside inline code must stay literal.
help([[
# Underscores in inline code

Two spans on one line: input `bids_input`, and work `bids_work`, folders.
One span with two underscores: `foo_bar_baz`.
Outside code, _note_ stays italic and __strong__ stays bold.

## List
- item `bids_input` and `bids_work` together
]])

whatis("Name: Inline code underscore")
whatis("Version: 1.0")
whatis("Description: Underscores inside inline code stay literal")
