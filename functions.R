library(pander)
library(stringr)
library(dplyr)
library(googlesheets4)
library(lubridate)
library(kableExtra)

gs4_deauth()

gscholar_stats <- function(url) {
  cites <- get_cites(url)
  return(paste(
    'Citations:', cites$citations, '|',
    'h-index:',   cites$hindex, '|',
    'i10-index:', cites$i10index
  ))
}

get_cites <- function(url) {
  html <- xml2::read_html(url)
  node <- rvest::html_nodes(html, xpath='//*[@id="gsc_rsb_st"]')
  cites_df <- rvest::html_table(node)[[1]]
  cites <- data.frame(t(as.data.frame(cites_df)[,2]))
  names(cites) <- c('citations', 'hindex', 'i10index')
  return(cites)
}

get_cv_sheet <- function(sheet) {
  return(read_sheet(
    ss = 'https://docs.google.com/spreadsheets/d/1yEYPdjQNqIw_lrOjUPDKjx9wMfzTeYrcdrtSDRj6Zhw/edit',
    sheet = sheet
  ))
}

make_ordered_list <- function(x) {
  return(pandoc.list(x, style = 'ordered'))
}

make_bullet_list <- function(x) {
  return(pandoc.list(x, style = 'bullet'))
}

make_ordered_list_filtered <- function(df, cat) {
  return(df %>%
           filter(category == {{cat}}) %>%
           mutate(
             citation = str_replace_all(
               citation,
               "\\\\\\*(\\w+),",
               "\\\\*\\\\underline{\\1},"
             )
           ) %>%
           pull(citation) %>%
           make_ordered_list()
  )
}

na_to_space <- function(x) {
  return(ifelse(is.na(x), '', x))
}

enquote <- function(x) {
  return(paste0('"', x, '"'))
}

markdown_url <- function(url) {
  return(paste0('[', url, '](', url,')'))
}

make_publication_card <- function(author, year, title, journal, number, doi, category) {
  # Extract year from parentheses
  year_clean <- gsub("[()]", "", year)

  # Create status badge
  status_badge <- if(grepl("Submitted", doi)) {
    '<span class="pub-badge pub-status">Under Review</span>'
  } else {
    '<span class="pub-badge pub-year">' %+% year_clean %+% '</span>'
  }

  # Category badge
  category_label <- case_when(
    category == "peer_reviewed" ~ "Journal Article",
    category == "working" ~ "Preprint",
    category == "white_paper" ~ "Report",
    category == "thesis" ~ "Thesis",
    category == "conference" ~ "Conference",
    TRUE ~ category
  )
  category_badge <- '<span class="pub-badge pub-category">' %+% category_label %+% '</span>'

  # Build card HTML
  card <- paste0(
    '<div class="publication-card">',
    '<div class="pub-header">',
    '<div class="pub-badges">', status_badge, ' ', category_badge, '</div>',
    '</div>',
    '<h3 class="pub-title">', gsub('"', '', title), '</h3>',
    '<p class="pub-authors">', author, '</p>',
    '<p class="pub-venue">', journal, ' ', number, '</p>',
    '<p class="pub-links">', doi, '</p>',
    '</div>'
  )

  return(card)
}

`%+%` <- function(x, y) paste0(x, y)
