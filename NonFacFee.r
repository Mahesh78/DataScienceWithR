# WHL Server

library(readxl);library(sqldf);library(xlsx)

state = read_excel('ss.xlsx',col_names = FALSE)
location = data.frame(state[seq(1,nrow(state),3),],state[seq(3,nrow(state),3),], state[seq(2,nrow(state),3),])
names(location) = c('ID','LocalityName','LocalityState')
write.xlsx(location, 'l17.xlsx',row.names = FALSE)

rawData0 = read.delim2('PFALL17A.txt', header = FALSE, sep = ',', colClasses = 'character')
rawData0[,c(6:7,12,13,15,16)] = sapply(rawData0[,c(6:7,12,13,15,16)],as.numeric)
rawData0$LocalityID = paste(rawData0$V2, rawData0$V3, sep = '')
rawData0[2:3] = NULL
rawData0[6] = NULL
names(rawData0) = c('Year','CPT_or_Level2HCPC','Modifier','NonFacilityFee','FacilityFee','PCTC_Indicator','StatusCode','MultipleSurgeryIndicator', '50%TherapyReductionAmount', '50%TherapyReductionAmountInstitutional','OPPS_Indicator','OPPS_NonFacilityFee','OPPS_FacilityFee','LocalityID')
location = read_excel('l17.xlsx')
df = sqldf('SELECT * FROM rawData0 LEFT JOIN location ON LocalityID = ID')
df[15] = NULL
MPFS = df[,c(1,14:16,2:13)]
write.csv(MPFS, file = 'mpfs17.csv',row.names=FALSE)