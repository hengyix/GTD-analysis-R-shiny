## GTD Visualization Illustration
The visualization is interactive and demonstrated using shiny application: https://hengyix.shinyapps.io/global-terrorism-analysis/ <br>
<br>
Global Terrorism Database (GTD) is a database including information on terrorist events from 1970 to 2020, based on open media sources. It is maintained by researchers at the National Consortium for the Study of Terrorism and Responses to Terrorism (START), headquartered at the University of Maryland.

Link to the official website of START: https://www.start.umd.edu/gtd/
<br>Database and Codebook can be accessed on the website.
The database is also included in the data folder. Please use git lfs to fetch the csv file because its size exceeds the 100MB limit.

The dashboard contains a spatial map showing global distribution of terrorist attacks from 1970 to 2020, bar plots demonstrating patterns in attack actors and attack types, and line plots for time series abalyses.

Here are tha packages in R involved:<br>
viridis <br>
tidyverse
<br>ggrepel
<br>shinythemes
<br>shiny
<br>maps
<br>terra
<br>shinydashboard
<br>plotly
<br>rlang
<br>RColorBrewer
