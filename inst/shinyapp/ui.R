library(shiny)
library(bslib)

ui <- page_sidebar(
  theme = bs_theme(bootswatch = "darkly"),
  sidebar = sidebar(
    img(src = "hexsticker.png", width = 150, style = "margin-left: auto; margin-right: auto;"),
    # Select variable for y-axis
    selectInput(
      inputId = "method",
      label = "Method",
      choices = c(
        "Random words" = "word",
        "Sentence method" = "sentence",
        "Phrase method" = "phrase"
      ),
      selected = "word"
    ),
    sliderInput("n", "How many words?",
        min = 1, max = 10, value = 4
      ),
    conditionalPanel(
      condition = "input.method == 'word'",
      sliderInput("min_size", "Word size",
        min = 2, max = 10, value = c(4, 6),
      ),
      radioButtons("cap", "Capitalisation",
        choices = c("original", "none", "title"),
        selected = "original"
      ),
      textInput("sep", "Separator",
        value = "-",
        placeholder = "e.g. a space, ';' or '-'"
      )
    ),
    conditionalPanel(
      condition = "input.method == 'sentence'",
      textInput("sep", "Separator",
        value = "-",
        placeholder = "e.g. a space, ';' or '-'"
      )
    ),
    actionButton("generate", "Generate password"),
  ),
  
  # Output: Generate password
  card(
    h3("Your new password"),
    h4(textOutput(outputId = "password"))
  ),
  card(
    h3("Password strength"),
    h4(textOutput(outputId = "password_strength")),
    h4(textOutput(outputId = "password_secrecy"))
  )
)
