#' Keep it secret, and keep it safe (with a password)
#' 
#' Password generator using text from the Lord of the Rings novels.
#' @param method string. Method to use for password generation.
#' @param ... pass arguments to password generator functions.
#' @return Returns a string with the generated password.
#' @examples
#' # generate a password using a random method
#' keepitsecret::keepitsafe("random")
#' @export
keepitsafe <- function(method = c("word", "phrase", "sentence", "random"), ...){
  method_vec <- pw_methods()
  m <- match.arg(method, choices = c("word", "phrase", "sentence", "random"))
  func <- switch(
    m,
    word = 'random_words',
    sentence = 'sentence_method',
    random = sample(method_vec, 1),
    phrase = 'phrase_method'
  )
  f <- get(func)
  f(...)
}

#' Password generator
#' 
#' Various methods for generating secure passwords.
#' @param n number of words
#' @param sep What is used to separate the words. Defaults to space.
#' @param cap Capitalisation of words. Options are to keep as they appear in the text,
#' no capitalisation, and capitalise each word.
#' @param ... pass arguments to \code{\link{lotr_words}}
#' @rdname pw-methods
random_words <- function(n = 4, cap = c("original", "none", "title"), sep = " ", ...){
  cap <- match.arg(cap, c("original", "none", "title"))
  words <- lotr_words(...)
  words_vector <- dplyr::slice_sample(words, n = n)$word
  if(cap == "none"){
    words_vector <- stringr::str_to_lower(words_vector)
  } else if(cap == "title"){
    words_vector <- stringr::str_to_title(words_vector)
  }
  out <- paste(words_vector, collapse = sep)
  return(out)
}

#' @rdname pw-methods
phrase_method <- function(n = 6, sep = ""){
  sen <- lotr_sentences(n)
  sen_words <- stringr::word(sen, 1, n)
  out <- paste(stringr::str_split_1(sen_words, " "), collapse = sep)
  return(out)
}

#' @param n integer. Number of words.
#' @rdname pw-methods
sentence_method <- function(n = 6){
  sen <- lotr_sentences(n)
  sen_words <- stringr::word(sen, 1, n)
  
  cat("reducing sentence: "); cat(sen_words); cat("\n")
  string_list <- stringr::str_split(sen_words, stringr::boundary("word"))
  paste(stringr::str_extract_all(string_list[[1]], "\\w{2}", simplify = T)[,1], collapse = "")
}
