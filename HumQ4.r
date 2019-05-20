

# All paid DOS 005 Average CPT per Visit
library(readxl);library(sqldf);library(xlsx)
hbook = read_excel('hbook.xlsx')
length(hbook$Ex_Code)  #111901
table(hbook$Ex_Code, useNA = "ifany")
hbook2 = data.frame(Subscriber_ID = hbook$Subscriber_ID,Member_Seq = hbook$Member_Seq, Service_Date = hbook$Service_Date, Ex_Code = hbook$Ex_Code)
table(hbook2$Ex_Code, useNA = "ifany")
hdf = sqldf('SELECT * FROM hbook2 WHERE Ex_Code IS NULL GROUP BY Subscriber_ID, Member_Seq, Service_Date')
str(hdf) #34,253

# 009 UM Activity 002a Total Visits
hTotalVisits = data.frame(Subscriber_ID = hbook$Subscriber_ID,Member_Seq = hbook$Member_Seq, Service_Date = hbook$Service_Date, Division = hbook$Division, Provider_ID = hbook$Provider_ID)
hTotalVisitsdf = sqldf('SELECT Division, Provider_ID, Subscriber_ID, Member_Seq, Service_Date FROM hTotalVisits GROUP BY Division, Provider_ID, Subscriber_ID, Member_Seq, Service_Date') 
head(hTotalVisitsdf)
hTotalVisitsdf1

# Visits approved 009 UM Activity 004a, 004b
hbook3 = data.frame(Subscriber_ID = hbook$Subscriber_ID,Member_Seq = hbook$Member_Seq, Service_Date = hbook$Service_Date, Division = hbook$Division, Provider_ID = hbook$Provider_ID, DOSStatus = hbook$DOSStatus)
hdf2 = sqldf('SELECT * FROM hbook3 WHERE DOSStatus = "Approved" GROUP BY Division, Provider_ID, Subscriber_ID, Member_Seq, Service_Date')
hdf3 = sqldf('SELECT Division, count(Division) as [count] FROM hdf2 GROUP BY Division')
hdf3

# Visits Partially Denied 009 UM Activity 005a, 005b, 005c
hbook3 = data.frame(Subscriber_ID = hbook$Subscriber_ID,Member_Seq = hbook$Member_Seq, Service_Date = hbook$Service_Date, Division = hbook$Division, Provider_ID = hbook$Provider_ID, DOSStatus = hbook$DOSStatus)
hdf4 = sqldf('SELECT * FROM hbook3 WHERE DOSStatus = "Partially Denied" GROUP BY Division, Provider_ID, Subscriber_ID, Member_Seq, Service_Date')
hdf5 = sqldf('SELECT Division, count(Division) as [count] FROM hdf4 GROUP BY Division')
nrow(hdf4)
hdf5

# Visits Denied 009 UM Activity 006

hdf6 = sqldf('SELECT * FROM hbook3 WHERE DOSStatus = "Denied" GROUP BY Division, Provider_ID, Subscriber_ID, Member_Seq, Service_Date')
hdf7 = sqldf('SELECT Division, count(Division) as [count] FROM hdf6 GROUP BY Division')
nrow(hdf6)
hdf7

# 007 Billed Amount

aa = sqldf('SELECT Division, sum(Billed_Price) as [count] FROM hbook GROUP BY Division')
aa


#hh = sqldf('SELECT Division, count(Division) as [count] FROM hTotalVisits GROUP BY Division, Provider_ID, Subscriber_ID, Member_Seq, Service_Date')


# Humana Analysis 5

h1 = sqldf('SELECT Provider_ID, Subscriber, Service_Date FROM hbook WHERE Ex_Code is NULL GROUP BY Provider_ID, Subscriber, Service_Date')
h2 = sqldf('SELECT Provider_ID, count(Service_Date) as len, count(DISTINCT(Subscriber)) as mem, count(Service_Date) / (count(DISTINCT(Subscriber))*1.0) as VisMem FROM h1 GROUP BY Provider_ID ORDER BY Provider_ID')
hn = subset(h2, VisMem > 4)

hnn = sqldf('SELECT Subscriber, Service_Date FROM hbook WHERE Ex_Code IS NULL AND Provider_ID IN (SELECT Provider_ID FROM hn) GROUP BY Subscriber, Service_Date')

# nrow(hnn)/length(unique(hnn$Subscriber))
# 22170/4005

hnn2 = sqldf('SELECT Subscriber, COUNT(Service_Date) as VisCt FROM hnn GROUP BY Subscriber')
str(hnn2) # 4005 Subscribers
hnn3 = subset(hnn2, VisCt < 8)
str(hnn3) # 2692 obs. of  2 variables



hnn4 = sqldf('SELECT Provider_ID, Subscriber, Service_Date FROM hbook WHERE Ex_Code IS NULL AND Provider_ID IN (SELECT Provider_ID FROM hn) GROUP BY Provider_ID, Subscriber, Service_Date')
hnn5 = sqldf('SELECT Provider_ID, Subscriber, COUNT(Service_Date) as VisCt FROM hnn4 GROUP BY Provider_ID, Subscriber')
str(hnn5)  # 4066 obs. of  3 variables
hnn6 = subset(hnn5, VisCt <= 8) #3536 obs. of  3 variables
# paste(hm$Provider_ID, collapse = ",") Comma Separated



# 2017

# Total Visits

ht = sqldf('SELECT Division, Provider_ID, Subscriber, Service_Date FROM hbook0 GROUP BY Division,Provider_ID, Subscriber, Service_Date')
> sum(sqldf('SELECT Division, count(Division) as [count] FROM ht GROUP BY Division')$count) 36938

# Partially Denied + Denied

hbook3 = sqldf('SELECT Division, Provider_ID, Subscriber, Service_Date, Ex_Code FROM hbook0')
> hdf2 = sqldf('SELECT * FROM hbook3 WHERE Ex_Code IS NOT NULL GROUP BY Division, Provider_ID, Subscriber, Service_Date')
> sum(sqldf('SELECT Division, count(Division) as [count] FROM hdf2 GROUP BY Division')$count)
[1] 21473

# Approved + partially approved

hdf2 = sqldf('SELECT * FROM hbook3 WHERE Ex_Code IS NULL GROUP BY Division, Provider_ID, Subscriber, Service_Date')
> sum(sqldf('SELECT Division, count(Division) as [count] FROM hdf2 GROUP BY Division')$count)
[1] 20867


# ('NA', 'NC','IP','NA2','MX','DP','18','256','197','NP','109','NE','MR1','011','NM','065','163','MRR')