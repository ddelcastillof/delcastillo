BIB    := src/references.bib
CSL    := csl/harvard-cite-them-right-no-et-al.csl
FILTER := src/bold-author.lua
BOLD_ONLY  := src/bold-only.lua
PUBS_HEAD  := src/head-pubs.html
HEAD   := src/head.html
FOOT   := src/foot.html

FRAGMENTS := docs/fragments/about.html \
             docs/fragments/research.html \
             docs/fragments/projects.html \
             docs/fragments/blog.html \
             docs/fragments/teaching.html

.PHONY: build clean

build: docs/index.html docs/publications.html docs/styles.css docs/images

# Assemble single-page site from fragments
docs/index.html: $(HEAD) $(FOOT) $(FRAGMENTS)
	cat $(HEAD) $(FRAGMENTS) $(FOOT) > $@

# About section (from index.md)
docs/fragments/about.html: src/index.md
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none

# Research section — uses citeproc + Lua filter to bold author name
docs/fragments/research.html: src/research.md $(BIB) $(CSL) $(FILTER)
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none \
	  --citeproc --bibliography=$(BIB) --csl=$(CSL) \
	  --lua-filter=$(FILTER)

# Projects section
docs/fragments/projects.html: src/projects.md
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none

# Blog section
docs/fragments/blog.html: src/blog.md
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none

# Teaching section
docs/fragments/teaching.html: src/teaching.md
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none

# Publications page (standalone — all papers, bold-only filter)
docs/fragments/publications.html: src/publications.md $(BIB) $(CSL) $(BOLD_ONLY)
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none \
	  --citeproc --bibliography=$(BIB) --csl=$(CSL) \
	  --lua-filter=$(BOLD_ONLY)

docs/publications.html: $(PUBS_HEAD) $(FOOT) docs/fragments/publications.html
	cat $(PUBS_HEAD) docs/fragments/publications.html $(FOOT) > $@

# Copy stylesheet
docs/styles.css: src/styles.css
	cp $< $@

# Copy images directory
docs/images: images
	cp -r images docs/images

clean:
	rm -f docs/index.html docs/publications.html docs/styles.css
	rm -rf docs/images docs/fragments
