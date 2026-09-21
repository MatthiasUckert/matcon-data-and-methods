# Shared by every page. Figures come from sample/package_numbers.csv, the parts of the data package from
# data/parts.csv and single values from _variables.yml; nothing here types a figure or a link.

numbers <- readr::read_csv(
  "sample/package_numbers.csv",  # every figure on the site comes from this file
  col_types = "cc"               # keys and values as text; num() converts a value where it is used
)

parts <- readr::read_csv(
  "data/parts.csv",    # the author's list of parts, with their state and links
  col_types = "ccccc"  # all text; Link stays empty until a part is published
)

vars <- yaml::read_yaml("_variables.yml")

# Large figures print as 49546773559, not 4.95e+10.
options(scipen = 99)

# One figure from package_numbers.csv. A missing or repeated key stops the render instead of printing a blank.
num <- function(key) {
  value <- numbers$Value[numbers$Key == key]
  if (length(value) != 1) {
    stop(
      "sample/package_numbers.csv has no single value for key ",  # where the figure should come from
      key                                                         # which figure is missing
    )
  }
  as.numeric(value)
}

# A link from _variables.yml, or the placeholder itself while the value is not decided; the TODO filter marks it.
link_or_gap <- function(url, text) {
  undecided <- grepl(
    "^TODO",  # a value not decided yet
    url       # read from _variables.yml
  )
  if (undecided) {
    return(url)
  }
  sprintf(
    "[%s](%s)",  # a markdown link
    text,        # what the reader sees
    url          # read from _variables.yml, never typed
  )
}

# " DOI ..." where a DOI is set, nothing where the value is empty because there is none yet.
doi_text <- function(doi) {
  if (!nzchar(doi)) {
    return("")
  }
  paste0(
    " DOI ",  # the label
    doi,      # read from _variables.yml, never typed
    "."       # the sentence ends with it
  )
}

# Files or bytes of the package besides its checksum manifest: the root and every part in data/parts.csv.
# package.files also counts MANIFEST.sha256 itself, so the pages sum the folders instead.
published_total <- function(what) {
  keys <- paste0(
    "folder.",                  # the per-folder keys of package_numbers.csv
    what,                       # files or bytes
    ".",                        # then the folder
    c("root", parts$Part)       # the root of the package and every published part
  )
  sum(vapply(
    keys,       # one key per folder
    num,        # read, never typed
    numeric(1)  # one figure per folder
  ))
}

# Whole numbers with thousands separators, as the paper prints them.
fmt_int <- function(x) {
  format(
    x,                  # the counts to print
    big.mark = ",",     # 1,462,939 rather than 1462939
    scientific = FALSE  # never 1.46e+06
  )
}

# Bytes in decimal units (1 GB = 10^9 bytes), three significant digits.
fmt_bytes <- function(bytes) {
  units <- c(
    "bytes",  # below 10^3
    "kB",     # 10^3
    "MB",     # 10^6
    "GB",     # 10^9
    "TB"      # 10^12
  )
  power <- floor(log10(bytes) / 3)
  paste(
    signif(
      bytes / 1000^power,  # the figure in the chosen unit
      3                    # three digits are enough to choose a download
    ),
    units[power + 1]  # the unit that keeps the number below 1000
  )
}

# What a reader can do with a part today. Only a published part gets a link; every other state is said in words.
part_state_one <- function(status, link) {
  if (status == "published" && !is.na(link)) {
    return(sprintf(
      "Published: [download](%s)",  # the only place a link is rendered
      link                          # read from data/parts.csv, never typed
    ))
  }
  if (status == "published") {
    return("Published, but data/parts.csv gives no link yet: TODO-LINK")
  }
  if (status == "request") {
    return(paste(
      "Available on request from",  # not downloadable; the author sends it
      vars$site$contact             # the contact in _variables.yml
    ))
  }
  if (status == "planned") {
    return("Planned: not yet available")
  }
  stop(
    "Unknown Status in data/parts.csv: ",  # the brief allows published, request and planned only
    status                                 # the value that is not one of them
  )
}

part_state <- function(status, link) {
  vapply(
    seq_along(status),  # one sentence per part
    function(i) part_state_one(
      status[i],        # the state of part i
      link[i]           # its link, if any
    ),
    character(1)        # exactly one string each
  )
}

# A link from _variables.yml where one is set; otherwise the sentence that stands in for it, with no placeholder
# shown. For things the site will offer later, such as the Stata do-files.
link_or_text <- function(url, text, otherwise) {
  if (grepl("^TODO", url) || !nzchar(url)) {
    return(otherwise)
  }
  sprintf(
    "[%s](%s)",  # a markdown link
    text,        # what the reader sees
    url          # read from _variables.yml, never typed
  )
}

# What the sample holds, counted from its files so that no page types these figures: the labelled contracts drawn
# from each detailed category, the rejected attachments, and every registrant copy of a few attachments filed by
# several registrants. A row that is none of these stops the render, because the pages would then misdescribe it.
sample_composition <- function() {
  contracts <- arrow::read_parquet("sample/core/Contracts.parquet")
  labels <- arrow::read_parquet("sample/core/Labels.parquet")
  labelled <- contracts$DocID %in% labels$DocID
  rejected <- contracts$Removed & !labelled
  copies <- !labelled & !rejected
  if (!all(contracts$MultFiler[copies] == 1)) {
    stop("sample/core/Contracts.parquet holds rows that are neither labelled, rejected nor multi-registrant copies")
  }
  per_category <- table(labels$ClassDetailed)
  list(
    rows = nrow(contracts),                                                 # every row of the sample
    labelled = sum(labelled),                                               # the labelled contracts
    categories = length(per_category),                                      # detailed categories drawn from
    per_category = unique(as.vector(per_category)),                         # contracts drawn from each
    rejected = sum(rejected),                                               # attachments the text screen rejected
    copy_rows = sum(copies),                                                # rows of multi-registrant attachments
    copy_attachments = length(unique(contracts$HashDocument[copies]))       # those attachments
  )
}
