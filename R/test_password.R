#' Is the password secret? Is the password safe?
#' 
#' Test the strength of a password (is it safe) and whether the password has been involved in a data breach (is it secret).
#' @details
#' The \code{is_it_secret()} function queries the [Pwned Passwords API](https://haveibeenpwned.com/API/v3#PwnedPasswords) for matches.
#' Have I been pwned (HIBP) uses k-anonymity to make sure searched passwords
#' stay secret. For more details see [haveibeenpwned.com](https://haveibeenpwned.com/API/v3#SearchingPwnedPasswordsByRange).
#' The \code{is_it_safe()} function tests the strength of your password using
#' [zxcvbn.js](https://github.com/dropbox/zxcvbn/blob/master/dist/zxcvbn.js).
#' zxcvbn.js has not been updated in a few years, so the estimates of time to
#' crack are likely overestimates.
#' @return If the password is not found in the database, the \code{is_it_safe()} function returns
#' a phrase 'You can keep your secret...'. If the password is present in the database,
#' the function returns the phrase 'Password found in database X times', where
#' X is the number of times the provided password appears in the HIBP database.
#' \code{is_it_safe()} prints the amount of time the password will take to crack at 10 guesses per second,
#' online with no throttling;
#' and, if the password is weak, prints warning and suggestions for improvement (if `verbose = TRUE`).
#' @param pw string. Password to test against Pwned Passwords database.
#' @rdname password-testing
#' @examples
#' \dontrun{
#' pw <- "password123"
#' is_it_secret(pw) # probably not...
#' is_it_safe(pw) # definitely not...
#' }
#' @export
is_it_secret <- function(pw){
  pw_sha1 <- openssl::sha1(pw)
  hash_prefix <- stringr::str_to_upper(stringr::str_extract(pw_sha1, "^\\w{5}"))
  hash_suffix <- stringr::str_to_upper(stringr::str_remove(pw_sha1, "\\w{5}"))
  base_url <- "https://api.pwnedpasswords.com/range/"
  req <- httr2::request(paste0(base_url, hash_prefix))
  resp <- httr2::req_perform(req)
  resp_string <- httr2::resp_body_string(resp)
  resp_tbl <- hash_to_tbl(resp_string)
  matches <- dplyr::filter(resp_tbl, hash == hash_suffix)
  if(nrow(matches) > 0){
    cli::cli_alert_warning(sprintf("Password found in database %s times", matches$n))
  } else {
    cli::cli_text("This password was not found in the Pwned passwords database")
    cat("\n")
    cli::cli_alert_success("All right, cousin Frodo! You can keep your secret for the present, if you want to be mysterious.")
  }
}

#' @param verbose logical. Whether or not to print output of strength estimator.
#' @references https://dropbox.tech/security/zxcvbn-realistic-password-strength-estimation
#' @rdname password-testing
#' @export
is_it_safe <- function(pw, verbose = T){
  output <- zxcvbn(pw)
  #seconds <- format(output$crack_times_seconds$online_no_throttling_10_per_second, scientific = F)
  score <- output$score
  
  if(score == 0){
    time <- cli::col_red(output$crack_times_display$online_no_throttling_10_per_second)
  } else if(score == 1){
    time <- cli::col_yellow(output$crack_times_display$online_no_throttling_10_per_second)
  } else if(score == 2){
    time <- cli::col_yellow(output$crack_times_display$online_no_throttling_10_per_second)
  } else if(score == 3){
    time <- cli::col_green(output$crack_times_display$online_no_throttling_10_per_second)
  } else if(score == 4){
    time <- cli::col_green(output$crack_times_display$online_no_throttling_10_per_second)
  }
  
  if(verbose == TRUE){
    cli::cli_text(
      "This password takes ", 
      cli::style_bold(time), 
      " ", 
      " to crack at 10 guesses per second."); 
    cat("\n")
    if(score >= 3){
      cli::cli_alert_success("You cannot pass. The dark fire will not avail you, flame of Udtn. Go back to the Shadow! You cannot pass. You cannot pass!")
    }
    if(length(output$feedback$suggestions) > 0){
      cli::cli_h2("Additional advice")
      cli::cli_alert_warning(output$feedback$warning)
      cli::cli_alert_info(output$feedback$suggestions)
    }
  }
  
  return(invisible(output))
}