
# Import Relevant Libraries

library(RSQLite)
library(shiny)
library(data.table)
library(randomForest)
library(caret)
library(e1071)
library(tidyr)
library(bslib)
library(stringr)
library(cookies)
library(shinyjs)
library(shiny.router)
library(svDialogs)
library(shinyalert)
library(brochure)

# Initialize some variables that will come in handy later

retry <- FALSE
value_old <- 0

# Read model (For more details refer to https://github.com/nsgLUMS/predict_DigitalLiteracy)
model <- readRDS("rf_model.rds")

# Connect to SQlite Database
db_path <- "dlappDB"
mydb <- dbConnect(RSQLite::SQLite(), dbname = db_path)

# Get initial count of rows of the DB
ID <- dbGetQuery(mydb, 'SELECT COUNT(*) FROM dlappDB')

# Creating a navlink for navigating back and forth through the webpages. For more details on how we made use of the "brochure" API, 
# visit https://github.com/ColinFay/brochure/blob/main/README.md

nav_links <- tags$ul(
  tags$li(
    tags$a(href = "/", "Home"),
  ),
  tags$li(
    tags$a(href = "/half", "Continue"),
  ),
  tags$li(
    tags$a(href = "/survey", "Survey"),
  ),
)

# Home Page 
Home <- function() {
  page(
    href = "/",
    
    # ui component
    ui <- fluidPage(
      useShinyjs(),
      tags$head(
        tags$style(HTML(
          "body {
        #background-color: rgb(52,3,85);
        background-color: rgb(26, 4, 41);
        #background-color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        color: white;
      }
      .main-container {
        padding: 20px;
        width: 500px;
        border-radius: 10px;
        text-align: center;
        position: absolute;
        top: 50%;
        left: 50%;
        scale: 0.8;
        transform: translate(-60%, -60%);

      }
      .main-title {
        # margin-top: 100px;
        margin-bottom: 20px;
        font-size: 2em;
        font-weight: bold;
        font-family: 'Open Sans', sans-serif;
        text-align: center;
        #margin-bottom: -200px;

      }
      .main-button {
        background-color: #4CAF50;
        color: white;
        padding: 15px 32px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 16px;
        margin: 4px 2px;
        cursor: pointer;
        border-radius: 5px;
        margin-top: 20px;
        background-image: linear-gradient(to right,rgb(225,242,77),rgb(99,217,183));
        margin-top: 0;
        color: rgb(52,3,85);
        font-weight: 700;
      }
      .bg-img {
        width: 100%;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -60%);
        z-index: -1;
        border-radius: 50%;
      }
      .blob-img {
        height: 120%;
        position: fixed;
        top: 60%;
        left: 50%;
        transform: translate(-50%, -60%);
        z-index: -2;
      }
      .img-spacer {
        height: 400px;
      }
      .neon-text {
        color: #fff;
        text-shadow: 0 0 10px #fff,
                     0 0 20px #fff,
                     0 0 30px #fff,
                     0 0 40px #ff00ea,
                     0 0 70px #ff00ea,
                     0 0 80px #ff00ea,
                     0 0 100px #ff00ea,
                     0 0 150px #ff00ea;
        font-family: 'Open Sans', sans-serif;
        
                }
      .neon-text:hover {
        color: white;
      }
      .main-text {
        margin-top: 70px;
        margin-bottom: 20px;
        font-size: 1.2em;
        font-family: 'Open Sans', sans-serif;
        text-align: justify;
      }"
        )),
      # Include div tags for questions, image, and hyperlinks
        tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Open+Sans&display=swap")
      ),
      img(class = "blob-img",src = "https://hunbalsohail.github.io/media/maaz-blob.png"),
      div(class = "main-container",
          img(class = "bg-img",src = "https://hunbalsohail.github.io/media/maaz-bg.png.jpeg"),
          h1(class = "main-title", "How Digitally Literate are you?"),
          div (class = "img-spacer"),
          p(class = "main-text", "A small survey consisting of seven questions designed to predict your Digital Literacy Score (between 0 and 1)"),
          actionButton("go_button", label = "Continue", class = "main-button"),
          tags$div(id = "dialog", class = "neon-text", "Redirecting..."),
          br(), br(),
          tags$div(id = 'hyper', class = "neon-text", "For more information regarding our research and model:"),
          tags$a('Link to the Code.||', href = 'https://github.com/nsgLUMS/predict_DigitalLiteracy', class = 'neon-text'),
          tags$a('Link to Our Research Paper.', href = 'https://www.dropbox.com/s/n3lg5cs1pq7sqtq/RR_DevEng_Digital_Literacy_Measures_Paper_2022.pdf?dl=0', class = 'neon-text')
      )
      
    ),
    
    # server component
    server <- function(input, output, session) {
      # Set retry to False
      retry <<- FALSE
      # hide the dialog box initially
      shinyjs::hide("dialog")
      # Get coount of observations
      ID <<- dbGetQuery(mydb, 'SELECT COUNT(*) FROM dlappDB')
      # Redirect User to second page once the "go_button" is clicked.
      observeEvent(input$go_button, {
        shinyjs::show("dialog")
        parse_cookie_string(
          get_cookies()
        )
        server_redirect("/lumsdlapp/half")
        # )
        
      })
    }
  )
}

##################################################################################################################################################################################

# Second Page
Continue <- function() {
  page(
    href = "/half",
    
    # ui component
    ui <- add_cookie_handlers(
      
      fluidPage(
        useShinyjs(),
        tags$head(
          tags$style(HTML(
            " body {
        #background-color: rgb(52,3,85);
        background-color: rgb(26, 4, 41);
        #background-color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        color: white;
      }
      .main-container {
        padding: 20px;
        width: 500px;
        border-radius: 10px;
        text-align: center;
        position: absolute;
        top: 50%;
        left: 50%;
        
        scale: 0.8;
        transform: translate(-60%, -60%);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
      }
      .main-title {
        margin-bottom: 20px;
        font-size: 2em;
        font-weight: bold;
        text-align: center;
      }
      .main-button {
        color: white;
        padding: 15px 32px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 16px;
        margin: 4px 2px;
        cursor: pointer;
        border-radius: 5px;
        margin-top: 20px;
        background-image: linear-gradient(to right,rgb(225,242,77),rgb(99,217,183));
        #margin-top: 0;
        color: rgb(52,3,85);
        font-weight: 700;
      }
      .main-text {
        margin-bottom: 0px;
        font-size: 1.5em;
        font-weight: 500;
        font-family: 'Open Sans', sans-serif;
        text-align: center;
        margin-bottom: 0px;
      }
      .main-text2 {
        margin-bottom: 20px;
        font-size: 1.5em;
        font-weight: 500;
        font-family: 'Open Sans', sans-serif;
        text-align: center;
        margin-bottom: 50px;
      }
      .neon-text {
        color: #fff;
        text-shadow: 0 0 10px #fff,
                     0 0 20px #fff,
                     0 0 30px #fff,
                     0 0 40px #ff00ea,
                     0 0 70px #ff00ea,
                     0 0 80px #ff00ea,
                     0 0 100px #ff00ea,
                     0 0 150px #ff00ea;
        font-family: 'Open Sans', sans-serif;
                }
      .question-text {
        margin-bottom: 10px;
        font-size: 1.2em;
        text-align: left;
        margin-bottom: -15px;
      }
      .question-box{
        
      }
      .bg-img {
        width: 100%;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -60%);
        z-index: -1;
        border-radius: 50%;
        opacity: 0.3;
      }
      .blob-img {
        height: 120%;
        position: fixed;
        top: 60%;
        left: 50%;
        transform: translate(-50%, -60%);
        z-index: -2;
        #filter: grayscale(100%);
      }
      .error-text {
        color: #ff0000;
        font-weight: bold;
        font-family: 'Open Sans', sans-serif;
        font-size: 16px;
        text-transform: uppercase;
        text-align: center;
        margin: 10px 0;
      }
    "))
        ),
        # Add div tags for image, questions (of type selectInput and numericInput), error handling
        img(class = "blob-img",src = "https://hunbalsohail.github.io/media/maaz-blob.png"),
        div(class = "main-container",
            img(class = "bg-img",src = "https://hunbalsohail.github.io/media/maaz-bg.png.jpeg"),
            h1(class = "main-title", "Almost There!"),
            p(class = "main-text", "Please enter your following information "),
            p(class = "main-text2", "before we move on to the survey."),
            
            div(class = "question-box",
                p(class = "question-text", "Age (between 10 and 120):"),
                numericInput("age", "", value = 10, min = 10, max = 120),
                p(class = "question-text", "Gender:"),
                selectInput("gender", "", choices = c("Female", "Male", "Other"), selected = "Male"),
                p(class = "question-text", "Education level:"),
                selectInput("education", "", choices = list("Primary School (till Grade 5)", "Secondary School (from Grade 6 to 12)", 
                                                            "Matric", "Intermediate",
                                                            "Bachelors", "Masters", "Above Masters")
                            , selected = "Primary School (till Grade 5)"),
            ),
            actionButton("go_button", label = "Continue to Survey", class = "main-button"),
            br(),br(),
            tags$div(id = "dialog", class = "neon-text", "Redirecting to Survey"),
            tags$div(id = "error_text", class = "error-text", "Please choose a valid age within the given range."),
            tags$div(id = "whole_text", class = "error-text", "Age must be a whole number.")
        )
      )),
    
    # server component
    server <- function(input, output, session) {
      
      # Initally hide every tag
      shinyjs::hide(id = "error_text")
      shinyjs::hide(id = 'whole_text')
      shinyjs::hide("dialog")
      # Get count of observations (neccessary for inserting into DB)
      ID <- dbGetQuery(mydb, 'SELECT COUNT(*) FROM dlappDB')
      
      # Make sure when the button is clicked, age is of correct type i.e. non-negative, integer and lies in the range (10 - 120)
      observeEvent(input$go_button, {
        
        # For checking if the cookie for the user exists or not
        
        cookieExists <- FALSE
        tryCatch({
          cookieExists <- !is.null(get_cookie("UserID"))
        }, error = function(e) {
          cookieExists <- FALSE
        }
        
        # Age question left blank
        if (is.null(input$age)) 
        {
          shinyjs::hide("whole_text")
          shinyjs::show("error_text")
          shinyjs::hide("dialog")
        }
        # check if age is whole number
        if (as.numeric(input$age) == round(as.numeric(input$age)))
        {
          # check if age lies in the range
          if (is.numeric(input$age) && input$age >= 10 && input$age <= 120) 
          {
            shinyjs::hide("whole_text")
            shinyjs::hide("error_text")
            shinyjs::show("dialog")
            
            # If cookie object of user exists i.e. the user is visiting more than once, simply insert the outputs of the question in the DB at row (ID + 1)
            
            if (!is.null(get_cookie("UserID")))
            {
              # Get cookie id
              UserID <- get_cookie("UserID")
              
              # Use value_old variable as a placeholder for the new "COUNT" of the DB
              value_old <<- ID + 1
              
              # Initalize query to send to DB. 
              # Note: Age, Gender, Education columns were filled with outputs as specified by the user. The rest of the columns have been assigned random values
              # which will be updated once the rest of the questions in the final page are answered. This way we can filter out people who tend to leave halfway
              # with the survey (represented by 0.01 DL score)
              # Note: The column for "cookie_id" has been assigned the UserID variable for identification purposes.
              insert_query <- paste("INSERT into dlappDB values(", as.character(value_old), ", ",
                                    as.character(input$age),
                                    ", \'", input$gender, "\' ",
                                    ", \'", input$education, "\', ",
                                    as.character(1), ", ",
                                    as.character(2), ", ",
                                    as.character(3), ", ",
                                    as.character(4), ", ",
                                    as.character(5), ", ",
                                    as.character(1), ", ",
                                    as.character(3),", ",
                                    as.character(UserID), ", ",
                                    as.character(0.01),
                                    ")", sep="")
              dbExecute(mydb, insert_query)
              
              # Redirect User to third page
              server_redirect("/lumsdlapp/survey")
            }  
            
            # If no cookie object of the user exists, assign new one based on the latest cookie assignemnt + 1.  The latest assignment is determined by a side-by-side
            # maintained csv file "cookies.csv". cookies.csv has only one column named "cookie_id" of numeric entries
            
            else
            {
            
              # For cookie assignment we choose a random number (integer) from 1 and 2 million inclusive
            
              value_old <<- ID + 1
              lower <- 1
              upper <- 2 * (10**6)
              var <- floor(runif(1, min = lower, max = upper))
              
              # Assign new user their cookie id
              cookies::set_cookie("UserID", var)
              
              # Again use value_old as a placeholder of the observation number, initialize query and execute same as above
              value_old <<- ID + 1
              
              insert_query <- paste("INSERT into dlappDB values(", as.character(value_old), ", ",
                                    as.character(input$age),
                                    ", \'", input$gender, "\' ",
                                    ", \'", input$education, "\', ",
                                    as.character(1), ", ",
                                    as.character(2), ", ",
                                    as.character(3), ", ",
                                    as.character(4), ", ",
                                    as.character(5), ", ",
                                    as.character(1), ", ",
                                    as.character(3),", ",
                                    as.character(var), ", ",
                                    as.character(0.01),
                                    ")", sep="")
              dbExecute(mydb, insert_query)
              
              # Redirect User to third and final page
              server_redirect("lumsdlapp/survey")
            }
            
          }
          # Error handling for incorrect age (blank or out of range input)
          else 
          {
            shinyjs::show("error_text")
            shinyjs::hide("dialog")
            shinyjs::hide("whole_text")
          } 
        }
        # Error handling for non-integer age
        else
        {
          shinyjs::show("whole_text")
          shinyjs::hide("error_text")
          shinyjs::hide("dialog")
        }
      })
    })
}

####################################################################################################################################################################
# Final Page/Survey
Survey <- function() {
  page(
    href = "/survey",
    
    # ui component
    ui <- fluidPage(
      
      useShinyjs(),
      tags$head(
        tags$style(HTML(
          "body {
          #background-color: rgb(52,3,85);
          background-color: rgb(26, 4, 41);
          display: flex;
          align-items: center;
          justify-content: center;
          flex-direction: column;
          color: white;
          font-family: sans-serif;
        }
        .bg-img {
          height = 50%
          width: 50%;
          position: fixed;
          top: 50%;
          left: 50%;
          transform: translate(-50%, -60%);
          z-index: -1;
          border-radius: 50%;
          opacity: 0.3;
          font-family: sans-serif;
          
        }
        .main-container {
          padding: 20px;
          width: 500px;
          border-radius: 10px;
          text-align: center;
          position: absolute;
          top: 50%;
          left: 50%;
          
        scale: 0.8;
        transform: translate(-60%, -60%);
          display: flex;
          align-items: center;
          justify-content: center;
          flex-direction: column;
          background-color: rgba(52,3,85, 0.3)
          font-family: sans-serif;
          
        }
        .main-title {
          margin-bottom: 20px;
          font-size: 2em;
          font-weight: bold;
          text-align: center;
          font-family: sans-serif;
          color: thistle
        }
        
        .main-button {
          color: white;
          padding: 15px 32px;
          text-align: center;
          text-decoration: none;
          display: inline-block;
          font-size: 16px;
          margin: 4px 2px;
          cursor: pointer;
          border-radius: 5px;
          margin-top: 20px;
          background-image: linear-gradient(to right,rgb(225,242,77),rgb(99,217,183));
          #margin-top: 0;
          color: rgb(52,3,85);
          font-weight: 700;
          font-family: sans-serif;
        }
        .main-text {
          margin-bottom: 20px;
          font-size: 1.2em;
          text-align: center;
          font-family: sans-serif;
        }
        .score {
          font-family: sans-serif;
          font-weight: 500;
          line-height: 1.1;
          color: brown;
        }
        
        .question-text {
          margin-bottom: 10px;
          font-size: 1.5em;
          text-align: center;
          font-family: sans-serif;
        }
        .blob-img {
          height: 120%;
          position: fixed;
          top: 60%;
          left: 50%;
          transform: translate(-50%, -50%);
          z-index: -2;
          #filter: grayscale(100%);
          font-family: sans-serif;
        }
        .score-box {
          top: 50%;
          left: 50%;
          padding: 10px 20px;
          border-radius: 5px;
          background-color: rgba(52,3,85, 0.3);
          color:white;
          box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
          font-size: 45px;
          transform: translate(-50%, -50%);
          z-index: 9999;
          opacity = 100%;
          font-family: sans-serif;
        }
        .neon-text {
          color: #fff;
          font-family: sans-serif;
          text-shadow: 0 0 10px #fff,
                      0 0 20px #fff,
                      0 0 30px #fff,
                      0 0 40px #ff00ea,
                      0 0 70px #ff00ea,
                      0 0 80px #ff00ea,
                      0 0 100px #ff00ea,
                      0 0 150px #ff00ea;
                  }
        .t1 {
        font-size: 20px;
        font-weight: bold;
        color: blue;
        text-align: center;
        font-family: sans-serif;
        }
        .error-text {
          color: #ff0000;
          font-weight: bold;
          font-size: 16px;
          text-transform: uppercase;
          text-align: center;
          margin: 10px 0;
          font-family: sans-serif;
        }
        .checkbox {
          width: 450px
        }
        
      "))
      ),
      
      # Initialize div tags for image, question, consent box, redirecting to home page, error handling
      
      img(class = "bg-img",src = "https://hunbalsohail.github.io/media/maaz-bg.png.jpeg", width = "600"),
      
      div(class = "main-container",
          h1(class = "main-title", "Finally! Take Our Survey now"),
          div(id = "questions", 
              selectInput("Q4", label = "Are you able to search/google things online?", 
                          choices = list("Yes" = 1, "No" = 0), 
                          selected = 1, width = "450"),
              HTML("<p> <strong>How familiar are you with the following computer and Internet-related items? Please choose a number
      between 1 and 5, where 1 represents no understanding and 5 represents full understanding of the item. </strong></p>"),
              radioButtons(inputId = "Q5", label = "Internet", choices = c(1 ,2, 3, 4, 5), selected = 1, inline = T),
              radioButtons(inputId = "Q6", label = "Browser", choices = c(1 ,2, 3, 4, 5), selected = 1, inline = T),
              
              radioButtons(inputId = "Q7", label = "PDF", choices = c(1 ,2, 3, 4, 5), selected = 1, inline = T),
              
              radioButtons(inputId = "Q8", label = "BookMark", choices = c(1 ,2, 3, 4, 5), selected = 1, inline = T),
              
              radioButtons(inputId = "Q9", label = "URL", choices = c(1 ,2, 3, 4, 5), selected = 1, inline = T),
              
              radioButtons(inputId = "Q10", label = "Torrent", choices = c(1 ,2, 3, 4, 5), selected = 1, inline = T),
              
              div(id = "check", checkboxInput("consent", "I give consent to store my information")),
              actionButton("go_button", label = "Score", class = "main-button"),
              br(),br(),
              tags$div(id = "dialog", class = "neon-text", "Server is ready for calculation..."),
              tags$div(id = "home_page", class = "neon-text", "Redirecting to Home Page..."),
              tags$div(id = "error_text", class = "error-text", "Please give consent to store your information"),
              actionButton("home_button", label = "Go to Home Page", class = "main-button"),
              tags$div(id = "retry", class = "neon-text", "Please go to home page to retry"),
          )
          
      )
    ),
    
    server <- function(input, output, session) {
      
      # Display Questions and hide error messages
      shinyjs::show(id = "dialog")
      shinyjs::show(id = "questions")
      shinyjs::show(id = 'check')
      shinyjs::hide(id = "home_page")
      shinyjs::hide(id = "retry")
      shinyjs::hide(id = 'error_text')
      
      # If user opts to go to home-page without filling the survey, do so
      observeEvent(input$home_button, {
        shinyjs::show("home_page")
        
        shinyjs::hide(id = 'retry')
        shinyjs::hide(id = 'dialog')
        server_redirect("/lumsdlapp/")
      })
      # User has clicked the "Score" button
      observeEvent(input$go_button, {
        # Observe if the user has already filled the survey and recieved their score. If yes, show corresponding error and advise to move to homepage for retry
        # purposes. Done to avoid spamming
        if (retry == TRUE)
        {
          shinyjs::show(id = 'retry')
          shinyjs::hide(id = 'dialog')
        }
        # Observe if the user has given consent to store their information. If not, display corresponding error message and do not return the DL score
        else if (input$consent) 
        {
          shinyjs::hide(id = 'error_text')
          
          # Create a reactive cell designed to create a dataframe with the appropriate columns, filled with entries from the survey. The dataframe is then 
          # used by the model for prediction which is then 
          datasetInput <- reactive({
            
            df <- data.frame(
              Name = c('term_pdf', 'term_internet', 'term_browser', 'term_bookmark', 
                       'term_url', 'search', 'term_torrent'),
              Value = as.character(c(input$Q7,
                                     input$Q5,
                                     input$Q6,
                                     input$Q8,
                                     input$Q9,
                                     input$Q4,
                                     input$Q10)))
            
            input <- transpose(df)
            
            test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
            
            Output <- data.frame(Prediction = predict(model,test))
            df['DL_Score'] <- Output
            
          })
          
          # Use the placeholder to update the values in place of the dummies set in second page
          UserID <- value_old
                    
          update_pdf_query <- paste("UPDATE dlappDB SET term_pdf =  ", as.character(input$Q7), " WHERE UserID =  ", as.character(UserID), 
                                    sep = "")
          dbExecute(mydb, update_pdf_query)
          
          update_term_internet_query <- paste("UPDATE dlappDB SET term_internet =  ", as.character(input$Q5), " WHERE UserID =  ", as.character(UserID), 
                                              sep = "")
          dbExecute(mydb, update_term_internet_query)
          
          update_term_browser_query <- paste("UPDATE dlappDB SET term_browser =  ", as.character(input$Q6), " WHERE UserID =  ", as.character(UserID), 
                                             sep = "")
          dbExecute(mydb, update_term_browser_query)
          
          update_term_bookmark_query <- paste("UPDATE dlappDB SET term_bookmark =  ", as.character(input$Q8), " WHERE UserID =  ", as.character(UserID), 
                                              sep = "")
          dbExecute(mydb, update_term_bookmark_query)
          
          update_term_url_query <- paste("UPDATE dlappDB SET term_url =  ", as.character(input$Q9), " WHERE UserID =  ", as.character(UserID),
                                         sep = "")
          dbExecute(mydb, update_term_url_query)
          
          update_search_query <- paste("UPDATE dlappDB SET search =  ", as.character(input$Q4), " WHERE UserID =  ", as.character(UserID), 
                                       sep = "")
          dbExecute(mydb, update_search_query)
          
          update_term_torrent_query <- paste("UPDATE dlappDB SET term_torrent =  ", as.character(input$Q10), " WHERE UserID =  ", as.character(UserID), 
                                             sep = "")
          dbExecute(mydb, update_term_torrent_query)
          
          update_DL_query <- paste("UPDATE dlappDB SET Dl_Score =  ", as.character(datasetInput()$Prediction[1]), " WHERE UserID =  ", as.character(UserID), 
                                   sep = "")
          dbExecute(mydb, update_DL_query)
          
          score <- round(datasetInput()$Prediction[1], 3)
          
          # Set up notification/pop-up message to display score
          shinyalert("Your Score: ", score, animation = 'slide-from-top', className = 'Score-box', 
                     confirmButtonText = 'Close')
        
          # Set retry to TRUE to avoid spamming
          retry <<- TRUE
        }
        # Error Handling for no conset provided
        else
        {
          shinyjs::show('error_text')
        }
        
      })
    })
}

brochureApp(
  Home(),
  Continue(),
  Survey()
)
