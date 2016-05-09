library(shiny)
library(ggplot2)

# Entry point for shiny apps.
function(input, output, session) {
  
  # Define the healt stats for you and the monsters
  you=3
  monster=3
  turn=1

  # Use observe to react dynamically to button clicks. The button has the id 
  # 'turn' and the field input$turn is >0 if the user clicked on the button. It 
  # is reset after the observe function finished.
  observe({
    if(input$turn > 0) {
      staticStatusText=paste("Turn: ", turn, ". Fighting with: ", input$name, ".", sep="")
      statustext<-staticStatusText
      
      # Deactivate select field once the button was clicked.
      session$sendCustomMessage(type="jsCode",
        list(code="$('.selectize-control').remove()"))

      # Roll the dice for you.
      randomDiceResult<-sample(1:6, 1)
      if(randomDiceResult==6){
        monster <<- monster-1
        statustext=paste(statustext, "You hit the monster.")
      }
      
      # Roll the dice for the monster
      randomDiceResult<-sample(c(monsters[1, input$name]:6), 1)
      if(randomDiceResult==6){
        you <<- you - 1
        statustext=paste(statustext, "Monster hit you.")
      }
      
      if(nchar(statustext)==nchar(staticStatusText)){
        statustext=paste(statustext, "Nothing happened.")
      }
      
      # If one died: Stop the game.
      if(you==0 || monster==0){
        # Taken from: https://gist.github.com/xiaodaigh/6810928
        session$sendCustomMessage(type="jsCode",
          list(code="$('#turn').prop('disabled',true)"))
      }
      
      # If you lost: Red background, deactivate button.
      if(you==0){
        session$sendCustomMessage(type="jsCode",
          list(code="$('body').css('background-color','#B40404')"))
        statustext=paste(statustext, "You lost.")
      }
      # If you won: Green background, deactivate button.
      if(monster==0){
        session$sendCustomMessage(type="jsCode",
                                  list(code="$('body').css('background-color','#088A08')"))
        statustext=paste(statustext, "You won.")
      }
      
      output$result=renderText(statustext)
      
      # Plot the current health.
      output$plot <- renderPlot({
        qplot(x=c("you", "monster"), y=c(you, monster))+
          geom_bar(stat = "identity")+scale_y_continuous(limits=c(0, 3))+
          labs(x="Party", y="Health", title="Health of you and monster")
      })
      
      turn <<- turn+1
    }
  })
  
  # Initial plot
  output$plot <- renderPlot({
    qplot(x=c("you", "monster"), y=c(you, monster))+
      geom_bar(stat = "identity")+scale_y_continuous(limits=c(0, 3))+
      labs(x="Party", y="Health", title="Health of you and monster")
  })
}