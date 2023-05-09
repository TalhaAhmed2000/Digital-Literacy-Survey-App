# Digital-Literacy-Survey-App
This app is an extension of the research done by Dr.Ihsan Ayub Qazi (LUMS Associate CS Professor), Dr.Agha Ali Raza (LUMS Assistant CS Professor), Dr.Ayesha Ali (LUMS Assistant Economics Professor). For more details of their research paper and github repository visit:

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
Digital technologies can play an important role in alleviating poverty and inequality by enabling access to economic opportunities (Jack and Suri 2014; Chun and Tang 2018; Hjort and Tian 2021). However, 43% of the developing world’s population or nearly 3 billion people, remain offline. This is despite the fact that 94% of the developing countries populations is covered by at least a 3G cellular network. One major barrier to closing the digital divide is the lack of digital literacy (Dimaggioet al. 2004; Zillien and Hargittai 2009; Rains and Tsetsi 2017; Hargittai and Micheli 2019). Digital literacy—defined as the ability to access and effectively find information online (Hargittai 2005; Gilster 1997) is the most often cited reason for why individuals are held back from taking up the Internet (World Bank 2021).
 
Digital literacy matters not only for Internet adoption, but also for effectively finding information in the digital space. Evidence from developing countries shows that digital technologies provide access to valuable information about markets, jobs, health, educational and financial ser-vices, but their benefits depend on complementary investments that enable effective use of these technologies such as infrastructure and skills (Aker and Blumenstock 2014; Wheeler et al. 2022; Dodson et al. 2013). Thus, digital literacy by enabling effective use of the digital technologies, can play a crucial role in expanding economic opportunities, thereby leading to human development and poverty reduction. Furthermore, several studies show that individuals with higher digital literacy are better at spotting fake news and misleading content online (Ali and Qazi 2022; Sirlin et al.2021;Muda et al. 2021;Flintham et al. 2018). Thus, digital literacy can help individuals become more discerning consumers of online content, which can in turn have positive effects on social and political behaviors (Levy 2021; Guriev et al. 2020; Zhuravskaya et al. 2020; Iyengar et al. 2019)


# How can you contribute?
This app is hopefully the first of the many steps to imporving the digital literacy in Pakistan. Adding additional features to the app is highly encouraged, more so if they help in the later data analysis part of the survey questionnaire. Some of them may include but not limited to:

- Having an interactive dashboard once the user is done filling the survey. The dashboard can show his/her percentile among all the participants and some basic statistics like mean, median etc. 
- A more interactive interface such as allowing user to see the history of their past attempts (if any). 
- Shiny Apps are generally optimized for 1-page web apps so we had to use the "brochure" API (see details: https://github.com/ColinFay/brochure/blob/main/README.md) for navigating back and forth between the webpages. Hence, transferring this to some other popular and efficient web frameworks like JavaScript or MERN stack would be highly appreciated and helpful. But some work might need to be done before for transferring the Random Forest Model from R to a new language.

To share feedback regarding any additions to the app, email at (add email here)

## Setting Up Shiny-server

Once one has installed *shiny server (visit https://posit.co/products/open-source/shinyserver/)*, to set up the configuration file, do the following:

```
# Access the configuration file in the etc/shiny-server directory
sudo nano /etc/shiny-server/shiny-server.conf
```
![Code_cdJ7IY1htO](https://user-images.githubusercontent.com/122668359/234613218-757f00a4-ee52-46dc-ae68-e03443582316.png)

Except from the *listen - port_number* option, the rest is pretty much default. This shows that the folder directory `/srv/shiny-server/` will have the shiny app and the logs of the shiny app will be stored in the directory `var/log/shiny-server`. The `directory_index on;` option simply specifies the `index.html` file to be rendered if the user visits the base URL.

## Location in the server

As seen from the configuration file, from the root, to access the main folder visit:
```
cd /srv/shiny-server/lumsdlapp
```
The folder `lumsdlapp` contains the following:

- `R` &#8594; contains the neccessay dependancies for the app
- `app.R` &#8594; contains the R-code for the shiny app. Any changes to the app can be done through here and would dynamically render if the app is deployed live.
- `cookies.csv` &#8594; Monitors the cookie assignment of unique users (see **app.R** for more details)
- `script.sql` &#8594; Contains the sql script from which the DB reads from
- `rf_model.rds` &#8594; Contains the Random Forest model. On more information on how to use it visit https://github.com/nsgLUMS/predict_DigitalLiteracy/blob/main/DL_model.rmd
- `dlappDB` &#8594; The database connected to SQlite script `script.sql` stores the responses. 

To create a SQlite DB (assuming it has been installed) and make it read from a sql script, run the following command on the terminal
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

## Starting Shiny Server
Once the configuration file and app is ready, to host it live, run the following command on the terminal. The code also shows how to check the *status* of the server i.e. whether the server is listening on the port or not. Its sample output is shown.

```
# To restart/start/stop the server
sudo systemctl restart/start/stop shiny-server

# To check the status
sudo systemctl status shiny-server
```
![Code_MPipjdsyMa](https://user-images.githubusercontent.com/122668359/234616014-010cdddc-8607-4ac3-95f5-4ccb871dd463.png)

The word `active` in bold then that means the server is listening on the specified port number. On the other hand `inactive` in bold, would mean the opposite and troubleshooting is required. In that case, troubleshoot of some sort like the following is required:

- Check whether the intended application is being listened to by the server. Do this by running the command `sudo lsof -i:port_number`. The followins shows a sample output for port 80.
```
sudo lsof -i:80
```
![Code_j03sCptnf7](https://user-images.githubusercontent.com/122668359/234619441-c881be5d-50ca-4ab2-adeb-0cc51a4083fb.png)

The figure is showing some service by the name of "apache2" is being listened to by the server at port 80. If it does not match with one's expectations, contacting the deployment team for clarification would help.

- Check the shiny server logs to see any discrepencies in the starting/stopping etc of the server. Do this by running the command `journalctl -u shiny-server`. 

**Note:** The latter command allows you to view the system journal, which contains logs for all services running on your system, including Shiny Server, and hence you may not have admin rights for it. 


## Logs 
In case the app after deployment is showing some issues, debugging would require going over the logs. Recall from the configuaration file that the logs were stored in  `var/log/shiny-server`. That can be done by the following command:

```
# Go to specified directory
cd /var/log/shiny-server

# Check the contents of the directory
ls
# Sample output: lumsdlapp-shiny-20230426-102617-45783.log

# Open log
sudo nano lumsdlapp-shiny-20230426-102617-45783.log 
```

The logs will show the all familiar output similar to when the app is run locally on R Studio. Therefore, it can help duebugging any problems with the app.

## Making Changes
It is highly recommended that one first creates a copy of the **app.R**. Make changes if one wants to and run it locally in R terminal (asuuming R is installed in the server machine) or R studio. Here one can troubleshoot more easily since the output window is in front without having the need to check the logs. Once that's done and it is error-free, one can move on to deploying it following the steps mentioned above.

