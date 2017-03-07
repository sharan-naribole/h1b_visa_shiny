# H-1B Petitions Data Exploration using Shiny

Shiny Dashboard web application to enable exploratory data analysis on H-1B Visa applications disclosure data in the period 2011-2016 

## Data Source

I utilize the transformed H-1B dataset obtained from the data wrangling performed [here!](https://github.com/sharan-naribole/H1B_visa_eda)

## Files

- [ui.r](https://github.com/sharan-naribole/H1b_visa_shiny/blob/master/ui.R)
- [server.R](https://github.com/sharan-naribole/H1b_visa_shiny/blob/master/server.R)
- [helpers.R](https://github.com/sharan-naribole/H1b_visa_shiny/blob/master/helpers.R)

These are the standard set of files used to build a Shiny app!

[Check out the app here!](https://sharan-naribole.shinyapps.io/h_1b/)

[Read the blog for more details!](http://blog.nycdatascience.com/student-works/h-1b-visa-applications-exploration-using-shiny/)

## App Inputs

The inputs to the app can be provided in the side panel. The app takes multiple inputs from user and provides data visualization corresponding to the related sub-section of the data set. Summary of the inputs:

### Year

Slider input of time period. When a single value is chosen, only that year is considered for data analysis.

### Job Type

Default inputs are Data Scientist, Data Engineer and Machine Learning. These are selected based on my personal interest. Explore different job titles for e.g. Product Manager, Hardware Engineer. Type up to three job type inputs in the flexible text input. I avoided a drop-down menu as there are thousands of unique Job Titles in the dataset. If no match found in records for all the inputs, all Job Titles in the data subset based on other inputs will be used.

### Location

The granularity of the location parameter is State with the default option being the whole of United States.

### Employer Name

The default inputs are left blank as that might be the most common use case. Explore data for specific employers for e.g., Google, Amazon etc. Pretty much similar in action to Job Type input.

### Metric

The three input metric choices are Total number of H-1B Visa applications, Certified number of Visa Applications and median annual Wage.

### Plot Categories

Additional control parameter for upper limit on the number of categories to be used for data visualization. Default value is 3 and can be increased up to 15.

## App Outputs

### Map

The Map tab outputs a map plot of the metric across the US for the selected inputs. In this case, the map is showing three layers. The first and bottom layer is roughly that of the US map. This is followed by the a point plot of the Metric across different Work sites in US with the bubble size and transparency proportional to the metric value. When only a particular state is selected in the app input instead of the default USA option, then the bubbles appear only for the selected state. The top most layer is that of pointers to the top N work sites with the highest metric values, where N stands for the Plot Categories input.

### Job Type

Job type tab compares the metric for the Job types supplied in the inputs. If none of the inputs match any record in our dataset, then all Job Titles are considered and the top N Job types will be displayed, where N stands for Plot Categories input. You can try this by providing blank inputs to the three Job Type text inputs. This output enables us to explore the Wages and No. of applications for different Job positions for e.g., Software Engineer vs Data Scientist. In the above figure, I am comparing Data Scientist against Data Engineer and Machine Learning positions. We can see an exponential growth in the number of H-1B visa applications for both Data Scientist and Data Engineer roles with Data Scientist picking up the highest growth.

### Location

Location tab compares the metric for the input jobs at different Worksites within the input Location region. In the above figure, the selected input was the default USA. In that case, the app displays the metric for the top N work sites, where N is the Plot Categories input. The top N sites are chosen by looking across all the years in the year range input. In the above example with default job inputs related to Data Science, we clearly observe San Francisco leading the charts closely followed by New York.

### Employers

The Employers tab output is similar to the Job Types tab with the only difference being the comparison of employers instead of Job Types. If no Employer inputs are provided or none of the provided match with any records in our dataset then all employers are considered. Figure 5 shows Facebook, Amazon and Microsoft as the leading employers for Data Science positions. 

## Acknowledgements

- [rdrop2](https://github.com/karthik/rdrop2)

- [lazyeval](https://cran.r-project.org/web/packages/lazyeval/index.html)

## License

Open sourced under the MIT License(LICENSE.md).
