# Examining the Landscape of Global Terrorism
## Introduction:
Global instability and political polarization have been on the rise for years, and the scourge of terrorism has been affecting countries across the globe. The focus of this research delves into countries that suffer most, terrorist groups that are responsible, and pattern of attack types applied. The research question is to examine features of terrorist activities from 1970 – 2020, including geographical distribution, most active groups and attack methods applied.<br><br>
Research into global terrorism is crucial within the context of public policy, as it helps formulate more effective and targeted policy measures to safeguard national and international security and provide the legal and ethical foundation for supporting counterterrorism efforts. Another motivation for solving this question is personal background in geopolitical conflicts and global security. Such visualization research is expected to facilitate further development in this field.<br><br>
Global Terrorism Database (GTD) is a database including information on terrorist events from 1970 to 2020, based on open media sources. It is maintained by researchers at the National Consortium for the Study of Terrorism and Responses to Terrorism (START), headquartered at the University of Maryland.<br><br>
Link to the official website:
< https://www.start.umd.edu/gtd/ >
<br>Database and Codebook can be accessed on the website.
<br>
<br>
## Mothed & Discussion: <br>
•	Geographic Distribution:<br><br>
This part is composed of a spatial map showing the influence of attack events from 1970 to 2020. There are two dimensions of measurement to be chosen from: number of attack events, and number of casualties. 
The conclusion of this graphic is that the terrorism has hit the global, and significant quantitative disparities exist across different regions. Iraq and countries located at South Asia have experienced most terrorist activities. <br><br>
![plot_screenshots/Picture1.png](plot_screenshots/Picture1.png) 
![plot_screenshots/Picture2.png](plot_screenshots/Picture2.png) 
 
By hovering the cursor, readers can see specific country names and corresponding values. The reason why a slider for time control is not added is that in each year, a very limited number of countries suffer from attacks, so a map does not make much sense. Also, each country shows huge disparity in attacks in different years, some countries suffer many attacks in one year but nearly no events afterwards. Therefore, an aggregate analysis functions better in identifying hotspots.<br><br>
But in case readers are interested in year-based data, a table is attached beneath the plot. Readers are allowed to define both year and the sorting order. All entries are kept here, since the table is expected not to be too long, and readers might hope to see all attack records.<br><br>
•	Top Perpetrators<br><br>
Next part aims to identify most active terrorist groups. Based on the previous map, the global are divided into three regions: Iraq, South Asia, and Other Regions. <br><br>
The conclusion from this graph is that entities behind the vast majority of terrorist incidents remain unknown, and there does not exist an identified entity active across the world. This is consistent with the criminal nature of terrorism, causing trouble to combating it. But when zooming into Iraq and South Asia, Islamic State of Iraq and the Levant (ISIL) and Taliban stand out respectively.<br><br>
![plot_screenshots/Picture3.png](plot_screenshots/Picture3.png)  
![plot_screenshots/Picture4.png](plot_screenshots/Picture4.png)  
<br>For this plot, labels on x axis are too long to show completely. Therefore, they are truncated and rotated. Some group names look similar after truncation: the difference in their names arises at the end, so interactivity is applied here. Groups are demonstrated according to proportion of events, rather than pure count of events, to improve persuasiveness. Unknown attackers are kept here because they can also convey information: groups behind the attacks are anonymous. The legend is removed here, since it tells no new information.<br><br>
Following the highlight of ISIL and Taliban, beneath this graph is the time-series analysis of these two groups. The rationale behind this analysis is that these two groups were accountable for a large proportion of events, prompting an examination of the specific trends over time in their actions.<br><br>
![plot_screenshots/Picture5.png](plot_screenshots/Picture5.png)  
<br>The graph indicates a period of rapid expansion followed by a significant decline in activity for ISIL, and overall a consistent intensification of activities over the years and a significant increase in the last decade for Taliban. <br><br>
The y-axis of the first plot has been calibrated to align with the second to avoid potential confusion. Nonetheless, extending the ISIL timeline back to 1995 would dilute the visual impact; the focus here is on illustrating each group's activity trends rather than a direct comparison. To maintain clarity regarding the distinct time frames, the first plot's x-axis labels have been accentuated and the title explicitly notes the respective time span.<br><br>
•	Attack Types<br><br>
Having gained insight into the locations of the attacks and the identities of the perpetrators, the focus now shifts to understanding the methodologies behind how these attacks are carried out. <br><br>
![plot_screenshots/Picture6.png](plot_screenshots/Picture6.png)  <br>
This analysis is still based upon the classification of three regions, and the plot (all three in shiny app) shows that bombings emerge as the most prevalent form of attack across the world, followed by armed assault. These two types constitute the overwhelming majority of attacks carried out between 1970 and 2020.<br><br>
Hover again is applied here to solve the problem of similarity after truncation. The bin of bombing/explosion is so long that it would make other bins hard to interpret if arranged vertically. Therefore, bins are located on y axis in this graph.<br><br>
Then, how did these two attack types change over time? After the bar plot comes time series analysis. While readers have the option to select the attack type of interest, bombing - being the most prevalent - is set as the default selection for a more focused examination. <br><br>
![plot_screenshots/Picture7.png](plot_screenshots/Picture7.png)  <br>
The plot shows that before 2010, there exists a disparity among the three regions, but after 2010, across the globe, there appeared a surge, shortly afterwards followed by a sharp drop. The parallel peaks, especially around 2014 and towards the end of the decade, suggest a global pattern of methods preferred. <br><br>
This graph is faceted over region. A drop-down box of region is not inserted here, because three lines presented together facilitate interpretation of trend over time across regions. Having to switch between different regions even within one type would lower readers and cause trouble in comparison. All the three plots share axes, also serving for the purpose of comparison.<br><br>
## Conclusion:
This visualization starts from a global overview, identifying hotspots, then examines top terrorist actors in these regions and their trend over time. Finally, it comes to attack methods applied. The rationale in each part is moving from the aggregate number in the four decades to a time series analysis from 1970 to 2020. 

## Link to Shiny App:
< https://hengyix.shinyapps.io/GTD-shiny/ >
