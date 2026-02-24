BIB   := src/references.bib
CSL   := csl/elsevier-vancouver-no-et-al.csl
TMPL  := src/template.html
CSS   := src/styles.css
PAGES := index cv teaching

.PHONY: build clean

build: $(addprefix docs/, $(addsuffix .html, $(PAGES))) \
       docs/research.html \
       docs/styles.css \
       docs/images

# Pages without bibliography
docs/%.html: src/%.md $(TMPL)
	pandoc $< -o $@ --template=$(TMPL) --standalone

# Research page uses citeproc
docs/research.html: src/research.md $(TMPL) $(BIB) $(CSL)
	pandoc $< -o $@ --template=$(TMPL) --standalone \
	  --citeproc --bibliography=$(BIB) --csl=$(CSL)

# Copy stylesheet
docs/styles.css: $(CSS)
	cp $< $@

# Copy images directory
docs/images: images
	cp -r images docs/images

clean:
	rm -f docs/*.html docs/styles.css
	rm -rf docs/images
