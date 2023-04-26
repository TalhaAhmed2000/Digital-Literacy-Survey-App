# Digital-Literacy-Survey-App
This app was designed by Junior students from LUMS School of Science and Engineering. Dr.Ihsan Ayub Qazi (Associate CS Professor) played an important role in guiding the students in this venture. Dr.Ihsan Ayub Qazi, Dr.Agha Ali Raza (Assitant CS Professor), Dr.Ayesha Ali (Assiant Economics Professor) have played an immense role in making this possible. For more details of their research paper and github repository visit:

- Research Paper: https://www.dropbox.com/s/n3lg5cs1pq7sqtq/RR_DevEng_Digital_Literacy_Measures_Paper_2022.pdf?dl=0
- Github: https://github.com/nsgLUMS/predict_DigitalLiteracy

## Overview
The web app is a small 7 question survey designed to predict digital literacy score (between 0 and 1). After the user provides basic information like "age", "gender" and "education level", the following 7 questions are asked:

Q1) Are you able to search/google things online? (Yes or No)

How familiar are you with the following computer and Internet-related items? Please choose a number between 1 and 5, where 1 represents no understanding and 5 represents full understanding of the item:

Q2) Internet
Q3) Browser
Q4) PDF
Q5) BookMark
Q6) URL
Q7) Torrent

For more details on why these combination of questions, refer to the research paper and on how to use the model developed, refer to the github

## Why Digital Literacy?
In Pakistan more than 50% of the population is below the poverty line and consequently have no access to education or even the basic "Internet" tools like searching up on Google or bookmarking tabs etc. Thus, from a policy intervention perspective, having a clear idea of the seriousness of the issue by quantifying a metric developed in the research paper, really goes a long way to improving the situation in Pakistan by providing and spending resources in areas most needed. 

# How can you contribute?
This app is hopefully the first of the many steps we will be taking to imporving the digital literacy in Pakistan. Adding additional features to the app is highly encouraged, more so if they help in the later data analysis part of the survey questionnaire. Some of them may include but not limited to:

- Having an interactive dashboard once the user is done filling the survey. The dashboard can show his/her percentile among all the participants and some basic statistics like mean, median etc. 
- A more interactive interface such as allowing user to see the history of their past attempts (if any). 
- Shiny Apps are generally optimized for 1-page web apps so we had to use the "brochure" API (see details: https://github.com/ColinFay/brochure/blob/main/README.md) for navigating back and forth between the webpages. Hence, transferring this to some other popular and efficient web frameworks like JavaScript or MERN stack would be highly appreciated and helpful. But some work might need to be done before for transferring the Random Forest Model from R to a new language.

## Location in the server
