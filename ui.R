library(shiny)
library(ggplot2)

fluidPage(
  # Taken from: https://gist.github.com/xiaodaigh/6810928
  tags$head(
    tags$script(HTML('
      Shiny.addCustomMessageHandler("jsCode",
        function(message) {
          eval(message.code);
        }
       );
     '
    )
  )),
  
  titlePanel("Fighting a monster"),
  
  fluidRow(column(12,
    p("Welcome to \"Fighting a monster\"."),
    p("\"Fighting a monster\" is a game in which you can fight against three different monsters, safely on your couch."),
    p("To start a game, ", strong("select a monster from the select input \"Monster\""), "(\"Nessie\" is selected by default). ", strong("Click \"Next turn\" to start a new turn."), " The monster selection will disapear (you cannot change mosters during a fight). ", strong("Hit \"Next turn\" again and again"), " until either you or the monster win."),
    p("For each turn, you will see the health status as well as some status information on the right hand side."),
    p("If the game is over you will have either a green background (you won) or a red background (you lost). Want to start a new game? Just reload the page.")
  )),
  
  sidebarPanel(
    
    selectInput('name', 'Monster', names(monsters)),

    actionButton("turn", "Next turn")
  ),
  
  mainPanel(
    plotOutput('plot'),
    verbatimTextOutput("result")
  )
)