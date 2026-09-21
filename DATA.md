# Data

The data of "The analysis of material contracts" are published as one package in five parts, each a folder
that can be downloaded on its own. The parts are shared from Google Drive, each with its own download
link. The site's data page (<https://matthiasuckert.github.io/matcon-data-and-methods/data.html>) gives each part's
size, number of files, status and link, read from `data/parts.csv` and `sample/package_numbers.csv`.

| Part | Folder | What it holds |
|:--|:--|:--|
| The database | `core/` | the tables with their codebooks, the contract index, the labelled sample, the keyword terms |
| Entity spans | `spans/` | one file per kind of entity, with its position in the document, and their codebook |
| The documents | `text/` | the documents as filed and as text, one file per document type and filing year |
| The classifiers | `models/` | one zip per task and context length, `models_index.csv`, `deployed.parquet` and a usage guide (`README.md`) |
| The extraction image | `lexnlp/` | the LexNLP container image, its lockfile, `NOTICE.md` and a usage guide (`README.md`) |

The root of the package holds `README.md` and `MANIFEST.sha256`, a SHA-256 checksum for every file of every part.
The tables are parquet files; no Stata files are published. StataNow reads parquet with `import parquet`.

The data are licensed under CC BY 4.0 and the classifiers under CC BY-SA 4.0, the licence of the model they were
trained from. The documents are filings the SEC made public on EDGAR. The extraction image contains LexNLP, which is
licensed under the AGPL-3.0; `lexnlp/NOTICE.md` gives the details. The licence texts are in `LICENSES/`.
