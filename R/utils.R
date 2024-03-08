# Password methods

pw_methods <- function(){
  c(
    "random_words",
    "sentence_method",
    "phrase_method"
  )
}

# create data frame of words including character count
get_words <- function(){
  utils::data("lotr", envir = environment())
  text_datf <- data.frame(txt = lotr)
  words_datf <- tidytext::unnest_tokens(text_datf, word, txt, to_lower = F)
  words_datf$count <- apply(words_datf, MARGIN = 1, nchar)
  return(words_datf)
}

# create data frame of sentences including word count
get_sentences <- function(){
  text_tbl <- data.frame(txt = lotr)
  # make sure full stop is not removed after Mr.
  text_tbl$txt <- stringr::str_remove(text_tbl$txt, "(?<=Mr)\\.")
  sen_tbl <- tidytext::unnest_sentences(tbl = text_tbl, sen, txt, to_lower = F, strip_punct = T) #|>
    #stringr::str_remove_all(sen, text_tbl$txt, "[.,':;’‘]")
  sen_tbl$wc <- apply(sen_tbl, MARGIN = 1, stringr::str_count, "\\w+")
  return(sen_tbl)
}

#' Function to get table of words
#' 
#' Extracts all unique words from the Lord of the Rings text.
#' @param min_size integer. Minimum number of letters.
#' @param max_size integer. Maximum number of letters.

lotr_words <- function(min_size = 4, max_size = NULL){
  
  word_tbl <- get_words()
  if(!is.null(max_size)){
    word_tbl <- dplyr::filter(word_tbl, count < max_size)
  }
  words <- word_tbl |>
    dplyr::filter(count > min_size) |>
    dplyr::distinct(word)
  return(words)
}

#' Extract random sentences
#' @param n minimum number of words in the sentence.
lotr_sentences <- function(n = 4){
  sentence_tbl <- get_sentences()
  sen <- sentence_tbl |>
    dplyr::filter(wc >= n) |>
    dplyr::slice_sample(n = 1)
  out <- sen$sen
  return(out)
}

# convert raw string of hashes to data frame with one row per response

hash_to_tbl <- function(x){
  resp_vector <- unlist(strsplit(x, "\r\n"))
  hash_tbl <- data.frame(hash = resp_vector)
  hash_tbl$n <- stringr::str_extract(hash_tbl$hash, "(?<=:)\\d+")
  hash_tbl$hash <- stringr::str_remove(hash_tbl$hash, ":\\d+$")
  return(hash_tbl)
}

# test password with zxcvbn.js

zxcvbn <- function(pw){
  ct <- V8::v8()
  #ct$source("https://raw.githubusercontent.com/dropbox/zxcvbn/master/dist/zxcvbn.js")
  ct$source(js_file_path("zxcvbn.js"))
  output <- ct$call("zxcvbn", pw)
  return(output)
}

js_file_path <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("js", package = "keepitsecret"))
  } else {
    system.file("js", path, package = "keepitsecret", mustWork = TRUE)
  }
}