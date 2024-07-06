
<!-- README.md is generated from README.Rmd. Please edit that file -->

# keepitsecret <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/bbartholdy/keepitsecret/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/bbartholdy/keepitsecret/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

:warning: **Early development** :warning:

This package will help you generate a strong password. Even better, the
password will contain words straight out of the Lord of the Rings novel!

It was heavily inspired by [this xkcd comic](https://xkcd.com/936/) and
[this Phoenix Nap blog
post](https://phoenixnap.com/blog/strong-great-password-ideas).

A Shiny app is available here:
<https://websaur.shinyapps.io/keepitsecret/>

## Installation

You can install the development version of keepitsecret like so:

``` r
devtools::install_github("bbartholdy/keepitsecret")
```

## Examples

To generate a password.

``` r
library(keepitsecret)
pw <- keep_it_safe()
pw
#> [1] "saluting-death’s-uniquely-enormous"
```

You can also test whether a password has been part of a data breach (is
it secret?)

``` r
is_it_secret(pw)
#> This password was not found in the Pwned passwords database
#> ✔ All right, cousin Frodo! You can keep your secret for the present, if you want to be mysterious.
```

and how strong is your password (is it safe?)

``` r
is_it_safe(pw)
#> This password takes centuries to crack at 10 guesses per second.
#> ✔ You cannot pass. The dark fire will not avail you, flame of Udtn. Go back to the Shadow! You cannot pass. You cannot pass!
```

Beware of common

``` r
is_it_secret("password1234")
#> ! Password found in database 48725 times
```

and weak passwords!

``` r
is_it_safe("password1234")
#> This password takes 19 minutes to crack at 10 guesses per second.
#> 
#> ── Additional advice ──
#> 
#> ! This is a very common password
#> ℹ Add another word or two. Uncommon words are better.
```

<figure>
<img src="https://i.imgflip.com/8gwn0y.jpg"
alt="yes, yes, this part is only in the movie…" />
<figcaption aria-hidden="true">yes, yes, this part is only in the
movie…</figcaption>
</figure>

## Shiny app

You can also use the Shiny app instead of the console.

``` r
runRing() # to rule them all
```
