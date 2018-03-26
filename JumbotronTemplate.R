# Load neccesary packages -----------------------------------------------------------

if(!"shiny" %in% installed.packages()) 
{ 
    install.packages("shiny") 
}
library(shiny)

if(!"shinyjs" %in% installed.packages()) 
{ 
    install.packages("shinyjs") 
}
library(shinyjs)

if(!"ggplot2" %in% installed.packages()) 
{ 
    install.packages("ggplot2") 
}
library(ggplot2)

if(!"xlsx" %in% installed.packages()) 
{ 
    install.packages("xlsx") 
}
library(xlsx)

if(!"shinythemes" %in% installed.packages()) 
{ 
    install.packages("shinythemes") 
}
library(shinythemes)

if(!"gridExtra" %in% installed.packages()) 
{ 
    install.packages("gridExtra") 
}
library(gridExtra)

if(!"shinyLP" %in% installed.packages()) 
{ 
    install.packages("shinyLP") 
}
library(shinyLP)

if(!"markdown" %in% installed.packages()) 
{ 
    install.packages("markdown") 
}
library(markdown)

if(!"shinyBS" %in% installed.packages()) 
{ 
    install.packages("shinyBS") 
}
library(shinyBS)

if(!"shinydashboard" %in% installed.packages()) 
{ 
    install.packages("shinydashboard") 
}
library(shinydashboard)

if(!"shinycssloaders" %in% installed.packages()) 
{ 
    install.packages("shinycssloaders") 
}
library(shinycssloaders)

# Define UI ---------------------------------------------------------------

ui <- navbarPage(id = "navbar", title = "Hello! This is a navbar",
                 theme = shinytheme("united"),
                 
                 tabPanel(id = "home", title = "Home", icon = icon("home"),
                          
                          tags$head(tags$style(
                              HTML('
                                   #toTask {
                                   background-color: #808080
                                   }
                                   
                                   #toTheory {
                                   background-color: #808080
                                   }
                                   
                                   #toAnalysis {
                                   background-color: #808080
                                   }
                                   
                                   #toManual {
                                   background-color: #808080
                                   }
                                   '))),
                          
                          jumbotron(header = "This is a try-out for a homepage", content = "This is a subheader", button = TRUE, buttonLabel = "Hello click this"),
                          
                          tags$a(
                              tags$img(style="position: absolute; top: 72px; right: 20px; border: 0; max-height: 100px;",
                                       src="logo.png")
                          ),
                          # Movie if you click on something
                          bsModal("modal", "Test video", "tabBut", size = "large" ,
                                  iframe(width = "560", height = "315", url_link = "https://www.youtube.com/embed/5xXRQoq-MqA")
                          ),
                          
                          fluidRow(
                              column(6, panel_div(class_type = "primary", panel_title = "Test", content = "Test bla bla")),
                              column(6, panel_div(class_type = "primary",panel_title = "Test2", content = "Test2 bla bla"))
                          ),
                          
                          fluidRow(
                              column(6,actionButton(inputId = "Test1",label = "Go test1")),
                              column(6, actionButton(inputId = "Test2",label = "Go test 2"))
                          ),
                          
                          br(),
                          br(),
                          
                          fluidRow(
                              column(6, panel_div(class_type = "primary", panel_title = "Test3", content = "Test3 bla bla")),
                              column(6, panel_div(class_type = "primary",panel_title = "Test4", content = "Test4 bla bla"))
                          ),
                          
                          fluidRow(
                              column(6,actionButton(inputId = "Test3",label = "Go test3")),
                              column(6, actionButton(inputId = "Test4",label = "Go test4"))
                          )
                 ),
                 
                 # Tab 1 UI ################################################################
                 
                 tabPanel(value = "Try1", title = "Test1", icon = icon("graduation-cap")),
                 
                 # Tab 2 UI ################################################################
                 
                 tabPanel(value = "Try2", title = "Test2", icon = icon("bar-chart"),
                          
                          tags$head(tags$style(
                              HTML('
                                   #sidebar {
                                   background-color: #EEEEEE;
                                   }
                                   
                                   #download_analysis {
                                   background-color: #FF5722
                                   }
                                   
                                   #link {
                                   color: #FF5722
                                   }
                                   
                                   #error {
                                   color: #ff0000
                                   }
                                   
                                   #final {
                                   color: #ff0000 
                                   }
                                   
                                   body, label, input, button, select { 
                                   font-family: "Arial";
                                   }')
                          )),
                          
                          headerPanel("Try"),
                          sidebarLayout(
                              sidebarPanel(id = "sidebar",
                                           useShinyjs()
                              ),
                              mainPanel(
                                  titlePanel("Results"),
                                  
                                  br(),
                                  textOutput(outputId = "error"),
                                  
                                  h3(textOutput(outputId = "final")),
                                  
                                  br(),
                                  
                                  withSpinner(plotOutput(outputId = 'RTplot'),color = "#FF5722"),
                                  
                                  downloadButton('download_analysis', 'Download')
                                  
                              )
                          )),
                 
                 # Tab 3 UI ################################################################
                 
                 tabPanel(value = "Try3", title = "Test3", icon = icon("graduation-cap")),
                 
                 # Tab 4 UI ######################################################################
                 tabPanel(value = "Try4", title = "Test4", icon = icon("book"))
                 
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {
    
    observeEvent(eventExpr = input$Test1,{
        updateTabsetPanel(session, inputId = "navbar",selected = "Try1")
    })
    
    observeEvent(eventExpr = input$Test2,{
        updateTabsetPanel(session, inputId = "navbar",selected = "Try2")
    })
    
    observeEvent(eventExpr = input$Test3,{
        updateTabsetPanel(session, inputId = "navbar",selected = "Try3")
    })
    
    observeEvent(eventExpr = input$Test4,{
        updateTabsetPanel(session, inputId = "navbar",selected = "Try4")
    })
    
}

# Have fun
shinyApp(ui = ui, server = server)
