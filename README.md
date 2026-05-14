# Academic Website

Personal academic website for Darwin Del Castillo. Bilingual static site (English at `/`, Spanish at `/es/`) built from per-language HTML fragments with Pandoc + GNU Make. Citations are sourced from a Paperpile `.bib` export.

## Tech Stack

- **Build**: Pandoc + citeproc, assembled with a `Makefile`
- **Bibliography**: BibTeX (`src/references.bib`) + CSL (`csl/harvard-cite-them-right-no-et-al.csl`)
- **i18n**: URL-based (`/` for EN, `/es/` for ES) with `hreflang` alternates
- **Styling**: Custom CSS, dark-mode toggle
- **Deployment**: GitHub Pages, serving from `/docs`

## Development

```bash
# Full build (EN + ES landing + standalone publications + styles + images)
make

# Clean and rebuild
make clean && make

# Preview locally
cd docs && python3 -m http.server 8765
# Open http://localhost:8765/ (EN) or http://localhost:8765/es/ (ES)
```

## License

[![CC BY-NC 4.0][cc-by-nc-shield]][cc-by-nc]

This work is licensed under a
[Creative Commons Attribution-NonCommercial 4.0 International License][cc-by-nc].

[![CC BY-NC 4.0][cc-by-nc-image]][cc-by-nc]

[cc-by-nc]: https://creativecommons.org/licenses/by-nc/4.0/
[cc-by-nc-image]: https://licensebuttons.net/l/by-nc/4.0/88x31.png
[cc-by-nc-shield]: https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg
