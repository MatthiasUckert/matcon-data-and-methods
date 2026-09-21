# matcon-data-and-methods

This repository holds the site of the data and methods of "The analysis of material contracts: Use of SEC
contractual data in accounting research" by Ann-Kristin Grosskopf, Victor Sehn and Matthias Uckert, together with
the sample its examples run on. The site says what the data package holds, how to get each part of it, how the
methods work, and where the code that built the database is; Quarto renders it from the `.qmd` files here into
`docs/`, which GitHub Pages serves. The data themselves are not in this repository; the site is at
<https://matthiasuckert.github.io/matcon-data-and-methods/>.

## Building the site

Quarto renders the `.qmd` files into `docs/`, which GitHub Pages serves. The render needs R with the packages
`arrow`, `dplyr`, `stringi`, `tibble`, `readr`, `knitr`, `yaml` and `DT`. The examples read only `sample/`, which the
pipeline writes and which is not edited here. What is not yet decided lives as placeholders in `_variables.yml` and
`data/parts.csv`.

## Licences

The site's code is under the MIT licence (`LICENSE`). `sample/` is an extract of the data package: its tables,
codebooks and span files are under CC BY 4.0 (`LICENSES/CC-BY-4.0.txt`), and the documents in `sample/text/` are
filings the SEC made public on EDGAR. `LICENSES/` also holds the other licences the package uses.
