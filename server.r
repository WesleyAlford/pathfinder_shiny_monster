library(shiny)
library(ggplot2)
library(plotly)

monster_data <- read.csv('P2E Monsters.csv')
roll <- 1:20
standard_dc <- matrix(c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,15,
                        16,17,18,19,20,21,22,23,25,26,28,29,31,32,34,35,36,38,
                        40),ncol = 2)
colnames(standard_dc) <- c('level','dc')

#level1<- monster_data[monster_data$Level == 1,]
#level1$fort_spell_fail_chance <- apply(t(replicate(19,roll)) + level1$Fort.Save <= 15,1,sum)/20
#level1$fort_spell_success_chance <- apply(t(replicate(83,roll)) + level1$Fort.Save > 15,1,sum)/20

function(input, output, session) {
  
  output$plot_density <- renderPlotly({
    selected_data <-monster_data[is.element(monster_data$Level-input$pc_level_control,
                                            input$rel_CR),]
    ggplotly(
      ggplot(selected_data,aes(
        apply(t(replicate(dim(selected_data)[1],roll)) 
              + Fort.Save <= standard_dc[input$pc_level_control,'dc'],1,sum)/20,
        y=..scaled..,
        color = as.factor(selected_data$Level-input$pc_level_control))) 
      + geom_density()
      + scale_x_continuous(labels = scales::percent)
      + labs(x = 'Chance monster fails to save'))
  })
  
  output$plot_ecdf <- renderPlotly({
    selected_data2 <-monster_data[is.element(monster_data$Level-input$pc_level_control,
                                             input$rel_CR),]
    selected_measure <- apply(t(replicate(dim(selected_data2)[1],roll)) 
                              + selected_data2$Fort.Save <= 
                                standard_dc[input$pc_level_control,'dc'],1,sum)/20
    ggplotly(
      ggplot(selected_data2[order(selected_measure)],aes(order(selected_measure),
                                                         color = as.factor(selected_data2$Level-input$pc_level_control))) 
      + stat_ecdf()
      
      + labs(x = 'Chance monster fails to save'))
  })
  
  output$test_text <- renderPrint({
    input$rel_CR
  })
  
  observe({
    pc_level <- input$pc_level_control
    
    updateCheckboxGroupInput(session,'rel_CR',choices = sort(unique(monster_data$Level)-pc_level),inline = TRUE)
  })
}