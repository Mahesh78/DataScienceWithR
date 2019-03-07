
library(readxl);library(sqldf);library(xlsx) # Load required libraries.

rawData0 = read.delim2('PFALL19.txt', header = FALSE, sep = ',', colClasses = 'character') # Read in the text file. Delete last few lines of text before reading in the data

rawData = rawData0[!(grepl('^\\d',rawData0$V5) | grepl('TC', rawData0$V5)),] # Taking out 'digits' and 'TC' or use rawData = rawData0[(grepl(' ',rawData0$V5)),]

table(rawData0$V5); table(rawData$V5) # Verifying counts of modifiers

MPFS = data.frame(locationID = paste(rawData$V2,rawData$V3,sep = ''), CPT_or_Level2HCPC = rawData$V4, NonFacilityPrice = as.numeric(rawData$V6),Modifier = rawData$V5) # Build new data frame based on required columns

location = read_excel('states.xlsx') # Read in location file for crosswalk

df = sqldf('SELECT a.locationID, b.locationName, a.CPT_or_Level2HCPC, a.NonFacilityPrice FROM MPFS a Left JOIN location b ON a.locationID = b.locationID') # Perform crosswalk

test = data.frame(df) # Duplicate dataframe for additional analysis

codes = c() # Paste the codes to be extracted for the report separated by commas e.g. c('99702', '97066')
length(codes) # Verify the counts match to that of numer of HCPC codes

fin = test[test$CPT_or_Level2HCPC %in% codes,] # Final output

write.xlsx(fin, file = 'MPFS_2019.xlsx') # Create a xlsx format of the output data frame
