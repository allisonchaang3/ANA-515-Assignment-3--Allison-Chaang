# ANA-515-Assignment-3--Allison-Chaang
Storm Data in 1997

Steps in this code:
1. Imported the csv. data into R (eventsdata). This original dataset has 51 columns and 41991 rows
2. Limited the dataset to only 21 columns – the beginning and ending dates and times, the episode ID, the
event ID, the state name and FIPS, the “CZ” name, type, and FIPS, the event type, the
source, and the beginning latitude and longitude and ending latitude and longitude 
3. Converted the beginning and ending dates to a DATETIME format
4. Changed the state and county column names to title case
5. Limited number of rows to those with CZ_TYPE="C" and dropped the CZ_TYPE column since they were standard across all rows
6. Padded the state and country FIPS with a 0 at the beginning of the values to standardize the number of integers
7. Changes column names to lower case
8. Created 2 new dataframes: one for all the states + area + region, another one with state + number of events
9. Merged these 2 datasets from #8 to create a plot


