BIB       := src/references.bib
CSL       := csl/harvard-cite-them-right-no-et-al.csl
FILTER    := src/bold-author.lua
BOLD_ONLY := src/bold-only.lua
PUBS_HEAD := src/head-pubs.html
FOOT      := src/foot.html

.PHONY: all publications styles clean

all: docs/index.html docs/publications.html docs/styles.css docs/images

# Assemble main page from 3 parts
docs/index.html: src/head-manual.html docs/fragments/research.html src/tail-manual.html
	cat src/head-manual.html docs/fragments/research.html src/tail-manual.html > $@

# Research fragment — featured (1st/2nd author) entries from references.bib
docs/fragments/research.html: src/research.md $(BIB) $(CSL) $(FILTER)
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none \
	  --citeproc --bibliography=$(BIB) --csl=$(CSL) \
	  --lua-filter=$(FILTER)

# Standalone publications page
docs/publications.html: $(PUBS_HEAD) $(FOOT) docs/fragments/publications.html
	cat $(PUBS_HEAD) docs/fragments/publications.html $(FOOT) > $@

docs/fragments/publications.html: src/publications.md $(BIB) $(CSL) $(BOLD_ONLY)
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none \
	  --citeproc --bibliography=$(BIB) --csl=$(CSL) \
	  --lua-filter=$(BOLD_ONLY)

docs/styles.css: src/styles.css
	cp $< $@

styles: docs/styles.css

docs/images: images
	cp -r images docs/images

publications: docs/publications.html

clean:
	rm -f docs/index.html docs/publications.html docs/styles.css
	rm -rf docs/images docs/fragments
