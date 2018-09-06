library(shiny)
library(ggplot2)
library(plotly)

monster_data <- read.csv('P2E Monsters.csv')
roll <- 1:20
standard_dc <- matrix(c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,15,
                        16,17,18,19,20,21,22,23,25,26,28,29,31,32,34,35,36,38,
                        40),ncol = 2)

#level1<- monster_data[monster_data$Level == 1,]
#level1$fort_spell_fail_chance <- apply(t(replicate(19,roll)) + level1$Fort.Save <= 15,1,sum)/20
#level1$fort_spell_success_chance <- apply(t(replicate(83,roll)) + level1$Fort.Save > 15,1,sum)/20

#ecdf

#html formatting
checkbox_style <-tags$head(
  tags$style(
    HTML(
      ".checkbox-inline { 
      margin-left: 0px;
      margin-right: 10px;
      }
      .checkbox-inline+.checkbox-inline {
      margin-left: 0px;
      margin-right: 10px;
      }
      "
    )
    ) 
    )

fluidPage(checkbox_style,
                fluidRow(
                  column(4,numericInput('pc_level_control','Player Character Level:',
                                        min = 1,max = 20,value = 1)),
                  column(4,checkboxGroupInput('rel_CR','Relative CR of enemies to display',
                                              choices = sort(unique(monster_data$Level)-1),
                                              inline = FALSE)),
                  column(4,checkboxGroupInput('save_type','Select save type(s) to view',
                                              choices = c('Fortitude','Will','Reflex')))),
                fluidRow(
                  column(6,plotlyOutput("plot_density")),
                  column(6,plotlyOutput("plot_ecdf"))
                ),
                fluidRow( verbatimTextOutput("test_text"))
)