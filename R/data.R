#' Lord of the Rings index
#' 
#' Metadata for \code{\link{lotr}}. Contains the chapter names, volume names, and line
#' numbers for the text, and can be used to locate these in the text.
#' @format A tibble with 62 rows and 7 variables:
#' \describe{
#'   \item{chapters}{A string denoting chapter number)}
#'   \item{name_orig}{A string denoting the original name of the chapter as it appears in the text}
#'   \item{name_clean}{A string with a clean version of the chapter name}
#'   \item{book}{A string denoting the Book number}
#'   \item{volume}{A string denoting the name of the volume}
#'   \item{line_start}{an integer denoting the line in the text where a given chapter starts}
#'   \item{line_end}{an integer denoting the line in the text where a given chapter ends}
#' }
"lotr_index"

#' Lord of the Rings text
#' 
#' The full text for the Lord of the Rings novel.
#' @format A character vector of length 41088
#' @source {J.R.R. Tolkien. 1954. The Lord of the Rings. HarperCollins e-books. <https://archive.org/details/tolkien-j.-the-lord-of-the-rings-harper-collins-ebooks-2010/page/n3/mode/2up>}
"lotr" 