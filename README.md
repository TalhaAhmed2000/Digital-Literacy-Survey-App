# Digital-Literacy-Survey-App
This app was designed by Junior undergraduate students from LUMS School of Science and Engineering. Dr.Ihsan Ayub Qazi (Associate CS Professor) played an important role in guiding the students in this venture. Dr.Ihsan Ayub Qazi, Dr.Agha Ali Raza (Assitant CS Professor), Dr.Ayesha Ali (Assiant Economics Professor) have played an immense role in making this possible. For more details of their research paper and github repository visit:

- Research Paper: https://www.dropbox.com/s/n3lg5cs1pq7sqtq/RR_DevEng_Digital_Literacy_Measures_Paper_2022.pdf?dl=0
- Github: https://github.com/nsgLUMS/predict_DigitalLiteracy

## Overview
The web app is a small 7 question survey designed to predict digital literacy score (between 0 and 1). After the user provides basic information like "age", "gender" and "education level", the following 7 questions are asked:

Q1) Are you able to search/google things online? (Yes or No)

How familiar are you with the following computer and Internet-related items? Please choose a number between 1 and 5, where 1 represents no understanding and 5 represents full understanding of the item:

- Internet                                                                                                                               
- Browser
- PDF 
- BookMark 
- URL 
- Torrent 

For more details on why these combination of questions, please refer to the research paper and on how to use the model developed, refer to the github

## Why Digital Literacy?
In Pakistan more than 50% of the population is below the poverty line and consequently have no access to education or even the basic "Internet" tools like searching up on Google or bookmarking tabs etc. Thus, from a policy intervention perspective, having a clear idea of the seriousness of the issue by quantifying a metric developed in the research paper, really goes a long way to improving the situation in Pakistan by providing and spending resources in areas most needed. 

# How can you contribute?
This app is hopefully the first of the many steps we will be taking to imporving the digital literacy in Pakistan. Adding additional features to the app is highly encouraged, more so if they help in the later data analysis part of the survey questionnaire. Some of them may include but not limited to:

- Having an interactive dashboard once the user is done filling the survey. The dashboard can show his/her percentile among all the participants and some basic statistics like mean, median etc. 
- A more interactive interface such as allowing user to see the history of their past attempts (if any). 
- Shiny Apps are generally optimized for 1-page web apps so we had to use the "brochure" API (see details: https://github.com/ColinFay/brochure/blob/main/README.md) for navigating back and forth between the webpages. Hence, transferring this to some other popular and efficient web frameworks like JavaScript or MERN stack would be highly appreciated and helpful. But some work might need to be done before for transferring the Random Forest Model from R to a new language.

## Setting Up Shiny-server

Once you have installed *shiny server (visit https://posit.co/products/open-source/shinyserver/)*, we have to set up the configuration file. The following shows the command and a sample output

```
# Access the configuration file in the etc/shiny-server directory
sudo nano /etc/shiny-server/shiny-server.conf

```
## Location in the server

From the root, to access the main folder visit:
![Code_gKnr6UMqK3](https://user-images.githubusercontent.com/122668359/234612836-f1bd111d-8d74-4a52-8968-a446955921b3.png)

```
cd /srv/shiny-server/lumsdlapp
```
The folder `lumsdlapp` contains the following:

- `R` &#8594; contains the neccessay dependancies for the app
- `cookies.csv` &#8594; Monitors the cookie assignment of unique users (see **app.R** for more details)
- `script.sql` &#8594; Contains the sql script from which the DB reads from
- `dlappDB` &#8594; The database connected to SQlite script `script.sql` stores the responses. 

To create a SQlite DB (assuming you have already installed it) and make it read from a sql script, run the following command on the terminal
```
# Create DB
sqlite3 dlappDB.db

# Read from script
.read script.sql
```

The coloumns for the DB are as follows:
  - *UserID* (Primary Key)
  - *Gender* (Responses $\in$ [Male, Female, Other])
  - *Education_Level* (Responses $\in$ [Primary School (till Grade 5), Secondary School (from Grade 6 to 12), Matric, Intermediate, Bachelors, Masters, Above Masters])
  - *term_pdf* (Responses $\in$ [1, 5])
  - *term_internet* (Responses $\in$ [1, 5])
  - *term_browser* (Responses $\in$ [1, 5])
  - *term_bookmark* (Responses $\in$ [1, 5])
  - *term_url* (Responses $\in$ [1, 5])
  - *search* (Responses can either by Yes(1) ir No(0))
  - *term_torrent* (Responses $\in$ [1, 5])
  - *cookie_id* \rightarrow keeps track of unique visitors
  - *DL_Score* (Responses $\in$ (0, 1))

- `rf_model.rds` &#8594; Contains the Random Forest model. On more information on how to use it visit https://github.com/nsgLUMS/predict_DigitalLiteracy/blob/main/DL_model.rmd
