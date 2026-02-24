# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal academic website built with Quarto, showcasing Darwin Del Castillo's professional profile as a physician-scientist and epidemiologist. The site is configured as a Quarto website project that renders to static HTML files.

## Repo Structure

delcastillo/
| src/            ← source files
|    |---- index.md
│    |---- cv.md
│    |---- teaching.md
│    |---- research.md
│    |---- template.html
│    |---- styles.css
│    |---- publications.bib  ← replace with Paperpile export
|---- csl/apa.csl     ← citation style
|---- images/         ← profile photo etc.
|---- docs/           ← built site (GitHub Pages)
|---- Makefile
|---- CLAUDE.md
|---- README.md

## Architecture

- **Build System**: Quarto website project with R integration
- **Output**: Static HTML files rendered to `/docs` directory
- **Content Structure**:
  - `index.qmd`: Main landing page with personal intro and social links
  - `cv.qmd`: CV page that embeds external PDF via iframe
  - `research.qmd`: Publications page with dynamic content from Google Sheets
  - `teaching.qmd`: Teaching information page
- **Data Integration**: Uses Google Sheets API via `googlesheets4` R package to dynamically pull publication data
- **Styling**: Uses Lux theme with custom CSS

## Key Configuration Files

- `_quarto.yml`: Main Quarto project configuration defining website structure, navigation, and output settings
- `functions.R`: R utility functions for data processing, Google Scholar stats, and Google Sheets integration

## Common Commands

### Build and Development

```bash
# Render the entire website
quarto render

# Preview the website locally with live reload
quarto preview

# Render a specific page
quarto render index.qmd
quarto render research.qmd
```

### Project Structure

- Source files (`.qmd`) are in the root directory
- Rendered HTML output goes to `/docs` directory (configured for GitHub Pages)
- R functions and utilities are in `functions.R`
- Images are stored in `/images` directory

## Data Dependencies

The research page dynamically pulls publication data from a Google Sheets document via the `get_cv_sheet()` function. The site uses `gs4_deauth()` for public sheet access without authentication.

## R Environment

Key R packages used:

- `googlesheets4`: Google Sheets API integration
- `dplyr`: Data manipulation
- `kableExtra`: Enhanced table formatting
- `pander`: Pandoc integration
- `rvest`/`xml2`: Web scraping for Google Scholar stats

## Future Development: Portfolio Page

### Planned Feature

Create a new `portfolio.qmd` page with a card-based grid layout (similar to https://smwhikeh.github.io/teaching/) to showcase projects, data analyses, and research outputs.

### Implementation Plan

1. **Create Google Sheet** with portfolio items containing:

   - `title` - Project name
   - `description` - Brief summary
   - `image_url` - Thumbnail/featured image URL
   - `category` - Project type (e.g., "Data Analysis", "Research", "Teaching", "Software")
   - `date` - Completion date
   - `project_url` - Link to GitHub/report/demo/publication
   - `tags` - Skills/tools used (comma-separated)
   - `featured` - Boolean to highlight key projects
2. **Create `portfolio.qmd`** with:

   - Featured projects section at top (3-column grid)
   - All projects section below, grouped by category
   - Card-based layout with hover effects
   - Each card displaying: thumbnail image, title, date, category badge, description snippet, link to project
3. **Update `_quarto.yml`**:

   - Add Portfolio to navbar
   - Position between Research and Teaching
4. **Add helper functions to `functions.R`**:

   - `make_portfolio_card()` - Generate HTML for individual project cards
   - Support for optional images (fallback to default/icon if no image)
5. **CSS Styling** (add to `styles.css`):

   - `.portfolio-grid` - Responsive 3-column grid layout
   - `.portfolio-card` - Card styling with images, hover effects
   - `.project-badge` - Category/tag badges
   - Mobile-responsive breakpoints

### Design Reference

Inspired by Hugo Academic theme portfolio layouts with emphasis on visual presentation, clear categorization, and easy navigation to project details.
