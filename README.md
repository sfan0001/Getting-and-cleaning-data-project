The README.txt that explains the analysis.R used to create tidy_data.txt.
- Download the dataset to a local directory
- Read all the tables from the directory into R as data frames
- First combine the tables with the same prefix in file names in test and training sets. Then column bind the resultant tables to one data frame
- Use information in features.txt to name columns of new dataframe
- Use regular expression to extract features regarding mean and standard devation and subset data only with these features
- Transform the new subset table:
    - Translate the activityname column to actual activity name
    - Substitute coloumn names into descriptive names by gsub command
- Group the new subset table by subject ID and Activity Name
- Calculate the mean for each group
- Write the results into "tidy_data.txt"
    
