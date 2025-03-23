PRESENTATIONS    := presentation.pdf
TEX_SUFS := .aux .log .nav .out .snm .toc .vrb .fdb_latexmk .fls

%.pdf:%.tex
	latexmk -pdflua $<

all: $(PRESENTATIONS)

clean:
	$(RM) $(foreach suf, ${TEX_SUFS}, $(PRESENTATIONS:.pdf=${suf})) *~
	$(RM) -r auto

clobber: clean
	$(RM) $(PRESENTATIONS)

