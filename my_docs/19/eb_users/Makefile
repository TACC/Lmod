TALKS    := talk.pdf
TEX_SUFS := .aux .log .nav .out .snm .toc .vrb .fdb_latexmk .fls

%.pdf:%.tex
	latexmk -pdflua $<

all: $(TALKS)

clean:
	$(RM) $(foreach suf, ${TEX_SUFS}, $(TALKS:.pdf=${suf})) *~
	$(RM) -r auto

clobber: clean
	$(RM) $(TALKS)

