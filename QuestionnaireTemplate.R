library(shiny)
library(ggplot2)

# Should be a folder within the shiny folder
outputDir <- "responses"

# Define the fields we want to save from the form
fields <- c("text_demo", "select_demo", "password_demo", "textarea_demo", 
            "slider_demo", "checkbox_demo", "cbgroup_demo", "date_demo", 
            "daterange_demo", "number_demo")

saveData <- function(input) {
    # put variables in a data frame
    data <- data.frame(matrix(nrow=1,ncol=0))
    for (x in fields) {
        var <- input[[x]]
        if (length(var) > 1 ) {
            # handles lists from checkboxGroup and multiple Select
            data[[x]] <- list(var)
        } else {
            # all other data types
            data[[x]] <- var
        }
    }
    data$submit_time <- date()
    
    # Create a unique file name
    fileName <- sprintf(
        "%s_%s.rds", 
        as.integer(Sys.time()), 
        digest::digest(data)
    )
    
    # Write the file to the local system
    saveRDS(
        object = data,
        file = file.path(outputDir, fileName)
    )
}

loadData <- function() {
    # read all the files into a list
    files <- list.files(outputDir, full.names = TRUE)
    
    if (length(files) == 0) {
        # create empty data frame with correct columns
        field_list <- c(fields, "submit_time")
        data <- data.frame(matrix(ncol = length(field_list), nrow = 0))
        names(data) <- field_list
    } else {
        data <- lapply(files, function(x) readRDS(x)) 
        
        # Concatenate all data together into one data.frame
        data <- do.call(rbind, data)
    }
    
    data
}

# Define questions
select_demo <- selectInput(
    "select_demo", 
    "Complete these famous lyrics:  
    \"I ***** ***** ***** down in Africa\"", 
    c("", 
      "bless the waves", 
      "sense the rain", 
      "bless the rain", 
      "guess it rains"
    )
)

radio_demo <- radioButtons(
    "radio_demo", 
    "Do you like Toto?",
    c("yes", "no"), 
    inline = TRUE
)

checkbox_demo <- checkboxInput("checkbox_demo", "I consent to more 80s music references")

cbgroup_demo <- checkboxGroupInput(
    "cbgroup_demo", 
    "Which artists had a UK number one single in the 80s?",
    c("Pat Benatar" = "pb",
      "Toto" = "toto",
      "Blondie" = "blon",           # atomic 1980-03-01
      "Kraftwerk" = "kw",           # computer love 1982-02-06
      "Dog Faced Hermans" = "dfh",
      "Eurythmics" = "eur",         # there must be an angel 1985-07-27
      "T'Pau" = "tpau"              # china in your hand 1987-11-14
    )
)

number_demo <- numericInput(
    "number_demo", 
    "How many UK number one songs did Madonna have in the 80s?", 
    min = 0, max = 20, step = 1, value = 0 # answer = 6
)

slider_demo <- sliderInput(
    "slider_demo", 
    "How would you rate the 80s musically, on a scale from 0-100?",
    min = 0, max = 100, step = 1, value = 50
)

date_demo <- dateInput(
    "date_demo", 
    "Africa by Toto reached its peak position of #3 in the UK charts on what date?",
    min = "1980-01-01", max = "1989-12-31", startview="decade"
    # right answer is 1983-02-26
)

daterange_demo <- dateRangeInput(
    "daterange_demo", 
    "What was the full UK Top 100 chart run of Africa by Toto?",
    min = "1980-01-01", max = "1989-12-31", startview="decade"
    # right answer is 1983-01-29 to 1983-04-09
)

text_demo <- textInput("text_demo", "What is your favourite 80s band?")
textarea_demo <- textAreaInput("textarea_demo", "What do you think about this exercise?")
password_demo <- passwordInput("password_demo", "Tell me a secret.")
action_demo <- actionButton("clear", "Clear Form")
download_demo <- downloadButton("download", "Download")
file_demo <- fileInput("file_demo", "Upload a PDF", accept = "pdf")
help_demo <- helpText("You can write help text in your form this way")


resetForm <- function(session) {
    updateTextInput(session, "text_demo", value = "")
    updateSelectInput(session, "select_demo", selected=character(0))
    updateRadioButtons(session, "radio_demo", selected = "yes")
    updateCheckboxInput(session, "checkbox_demo", value = FALSE)
    updateCheckboxGroupInput(session, "cbgroup_demo", selected=character(0))
    updateTextAreaInput(session, "textarea_demo", value = "")
    updateTextInput(session, "password_demo", value = "")
    updateSliderInput(session, "slider_demo", value = 50)
    updateDateInput(session, "date_demo", value = NA)
    updateDateRangeInput(session, "daterange_demo", start = NA, end = NA)
    updateNumericInput(session, "number_demo", value = 0)
}

# Set up questionnaire interface ----
ui <- fluidPage(
    title = "Questionnaire Framework",
    # CSS ----
    # stop the default input containers being 300px, which is ugly
    tags$head(
        tags$style(HTML("
                        .shiny-input-container:not(.shiny-input-container-inline) {
                        width: 100%;
                        max-width: 100%;
                        }
                        "))
        ),
    
    # App title ----
    h3("My Survey"),
    
    p("Please fill out the following brief survey..."),
    
    fluidRow(
        column(width=6, text_demo),
        column(width=6, password_demo)
    ),
    
    fluidRow(
        column(width=4,
               select_demo,
               radio_demo,
               checkbox_demo
        ),
        column(width=4, 
               cbgroup_demo
        ),
        column(width=4, 
               number_demo
        )
    ),
    
    slider_demo,
    date_demo,
    daterange_demo,
    textarea_demo, 
    
    actionButton("submit", "Submit"),
    action_demo
        )

# Reactive functions ----
server = function(input, output, session) {
    
    # When the Submit button is clicked, save the form data
    observeEvent(input$submit, {
        saveData(input)
        resetForm(session)
        
        # thank the user
        n_responses <- length(list.files(outputDir))
        response <- paste0("Thank you for completing the survey! You are respondant ",
                           n_responses, ".")
        showNotification(response, duration = 0, type = "message")
    })
    
    # clear the fields
    observeEvent(input$clear, {
        resetForm(session)
    })
}

shinyApp(ui, server)