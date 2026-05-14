BIB       := src/references.bib
CSL       := csl/harvard-cite-them-right-no-et-al.csl
FILTER    := src/bold-author.lua
BOLD_ONLY := src/bold-only.lua
FOOT      := src/foot.html

.PHONY: all publications styles clean

all: docs/index.html docs/es/index.html \
     docs/publications.html docs/es/publications.html \
     docs/styles.css docs/images

# ── English landing ──
docs/index.html: src/head-en.html docs/fragments/research-en.html src/tail-en.html
	cat src/head-en.html docs/fragments/research-en.html src/tail-en.html > $@

docs/fragments/research-en.html: src/research-en.md $(BIB) $(CSL) $(FILTER)
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none \
	  --citeproc --bibliography=$(BIB) --csl=$(CSL) \
	  --lua-filter=$(FILTER)

# ── Spanish landing ──
docs/es/index.html: src/head-es.html docs/fragments/research-es.html src/tail-es.html
	@mkdir -p docs/es
	cat src/head-es.html docs/fragments/research-es.html src/tail-es.html > $@

docs/fragments/research-es.html: src/research-es.md $(BIB) $(CSL) $(FILTER)
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none \
	  --citeproc --bibliography=$(BIB) --csl=$(CSL) \
	  --lua-filter=$(FILTER)

# ── English publications ──
docs/publications.html: src/head-pubs-en.html docs/fragments/publications-en.html $(FOOT)
	cat src/head-pubs-en.html docs/fragments/publications-en.html $(FOOT) > $@

docs/fragments/publications-en.html: src/publications-en.md $(BIB) $(CSL) $(BOLD_ONLY)
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none \
	  --citeproc --bibliography=$(BIB) --csl=$(CSL) \
	  --lua-filter=$(BOLD_ONLY)

# ── Spanish publications ──
docs/es/publications.html: src/head-pubs-es.html docs/fragments/publications-es.html $(FOOT)
	@mkdir -p docs/es
	cat src/head-pubs-es.html docs/fragments/publications-es.html $(FOOT) > $@

docs/fragments/publications-es.html: src/publications-es.md $(BIB) $(CSL) $(BOLD_ONLY)
	@mkdir -p docs/fragments
	pandoc $< -o $@ --wrap=none \
	  --citeproc --bibliography=$(BIB) --csl=$(CSL) \
	  --lua-filter=$(BOLD_ONLY)

# ── Shared assets ──
docs/styles.css: src/styles.css
	cp $< $@

styles: docs/styles.css

docs/images: images
	rm -rf $@ && cp -r $< $@

publications: docs/publications.html docs/es/publications.html

clean:
	rm -f docs/index.html docs/publications.html docs/styles.css
	rm -f docs/es/index.html docs/es/publications.html
	rm -rf docs/images docs/fragments docs/es
