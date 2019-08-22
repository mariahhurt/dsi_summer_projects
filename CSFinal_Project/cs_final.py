# -*- coding: utf-8 -*-
"""
Created on Fri Jul 26 20:33:37 2019

@author: Arti Patel
"""

#Arti Patel, Elizabeth Driskill, Mariah Hurt, and Sania Rasheed
#Ap8qk, Ekd6bx, Mes3wv, Sr2xn

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import datetime as dt

'''
read in files as df===============================================
'''
features = pd.read_csv('features.csv')
sampleSubmission = pd.read_csv('sampleSubmission.csv')
stores = pd.read_csv('stores.csv')
test = pd.read_csv('test.csv')
train = pd.read_csv('train.csv')

'''
check out what column headers in files look like ============
'''
features.head()
#store, date, temp, fuelprice, markdown1-5, CPI, unemployment, isholiday
sampleSubmission.head()
#ID, weeklySales
stores.head()
#store, type, size
test.head()
#store, dept, date, isholiday
train.head()
#store, dept, date, weeklySales, isHoliday

'''
Merging train df with features df ===========================
'''
#create datestore key in train file so that we can merge with features file
train['datestore'] = list(zip(train.Date, train.Store))
#group by Date+Store and sum up weekly sales for each
#this collapses all the dept per store and sums up sales per store
sums=train['Weekly_Sales'].groupby([train['Date'],train['Store']]).sum()
#makes df
sumsdf=pd.DataFrame(sums)
#makes datestore key the index
sumsdf["datestore"]=sumsdf.index
#makes key for features df so that merge is possible
features['datestore'] = list(zip(features.Date, features.Store))
#merge on datestore
#will only end up with 6,435 rows since merging left on sumsdf
merge = features.merge(sumsdf, left_on='datestore', right_on='datestore')

#convert date to datetime type
merge["Date"] = pd.to_datetime(merge["Date"])
#make another column for month+year for plots
merge["month_year"] = merge['Date'].dt.to_period('M')

merge['month'] = merge['Date'].dt.month
merge['year']= merge['Date'].dt.year
#Make a new column called store month  tht combines store with month so we can
#look at the average temp at a particular store in a particular month
merge['storemonth'] = list(zip(merge.Store, merge.month))
merge['storeyear']=list(zip(merge.Store, merge.year))

#Make a dataframe with the weekly sales for each store so that we can graph it
dfavgweek=merge['Weekly_Sales'].groupby(merge['Store']).mean()   
ax = dfavgweek.plot.bar(rot=0, figsize=(20,10))
print(ax)


#make plots for sales data over time
for title, group in merge.groupby('Store'):
    group.plot(x='Date', y='Weekly_Sales', title=title, legend=True)
    group.plot(x='Date', y='Fuel_Price', title=title, legend=True)
    group.plot(x='Date', y='Unemployment', title=title, legend=True)

#brings together info from stores df by merging
df_weekly = merge.merge(stores, left_on='Store', right_on='Store')


'''
Make df monthly by taking avg of quant var and sum of sales
'''
#makes month_year_store key
df_weekly['month_store'] = list(zip(df_weekly.month_year, df_weekly.Store))

#create df where condensed by month
df_monthly = (df_weekly.groupby('month_store', as_index=False)
       .agg({'Temperature':'mean', 'Fuel_Price':'mean','CPI':'mean','Unemployment':'mean','Weekly_Sales':'sum'})
       .rename(columns={'Temperature':'Temp_monthlyAvg', 'Fuel_Price':'fuelPrice_monthlyAvg','CPI':'CPI_monthlyAvg','Unemployment':'unemployment_monthlyAvg','Weekly_Sales':'Monthly_Sales'}))

df_monthly["Store"] = df_monthly["month_store"].str[1]
df_monthly["Month"] = df_monthly["month_store"].str[0]
df_monthly = df_monthly.merge(stores, left_on='Store', right_on='Store')


#this iterates through the stores in df grouped by store and plots monthly sales vs month
for title, group in df_monthly.groupby('Store'):
    group.plot(x='Month', y='Monthly_Sales', title=title, legend=True)
    
#this iterates through each month of the dataset and plots monthly sales vs store
for title, group in df_monthly.groupby('Month'):
    group.plot.scatter(x='Store', y='Monthly_Sales', c='Size',title=title, legend=True)


'''
df for sales of year
'''
saleyear = merge['Weekly_Sales'].groupby(merge['storeyear']).sum()
saleyeardf=pd.DataFrame(saleyear)
saleyeardf["storeyear"]=saleyeardf.index
saleyeardf.rename(columns={"Weekly_Sales": "Annual_Sales"}, inplace=True)

'''
To check rows of df
'''
def mergerows(df):
    print(df.count)
mergerows(merge)
    
'''
Some def functions to pull queries
'''
def averageSales(num):
    average=df_weekly['Weekly_Sales'].groupby(df_weekly['Store']).mean()
    print(average[num])
    return(average[num])

num = int(input("Hello! Please input your store number."))

print ("For store number " + str(num) + " the average weekly sales in USD is: $ "
       + str(averageSales(num)))


#A function to look at the average december temperature for a particular store
def averageDecTemp(num):
    temp=merge['Temperature'].groupby(merge['storemonth']).mean()
    print(temp[num, 12])
    return(temp[num, 12])
    
#Returns the total annual sales for a specified store number and year 
def annualSales(num, year):
    print(float(saleyeardf['Annual_Sales'].loc[saleyeardf["storeyear"]==(num,year)].values[0]))
    
type(annualSales(5,2010))

'''
some plots
'''
# Making scatterplots to visualize how certain variables affect weekly sales
scatter1 = merge.plot.scatter(x = "Fuel_Price", y = "Weekly_Sales")
print(scatter1)
scatter2 = merge.plot.scatter(x = "Temperature", y = "Weekly_Sales")
print(scatter2)
scatter3 = merge.plot.scatter(x = "CPI", y = "Weekly_Sales")
print(scatter3)
scatter4 = merge.plot.scatter(x = "Unemployment", y = "Weekly_Sales")
print(scatter4)




dataSource = 2
if dataSource==1:
    train = mergeData(pd.read_csv('train.csv'))
    test = mergeData(pd.read_csv('test.csv'))
    train['Split'] = 'Train'
    test['Split'] = 'Test'
    test.head()
else: 
    train = pd.read_csv('train.csv')
    test = pd.read_csv('test.csv')
    train['Split'] = 'Train'
    test['Split'] = 'Test'
    test.head()
 
t_len = len(train)    
df = pd.concat([train,test],axis=0)

medians = pd.DataFrame({'Median Sales' :df.loc[df['Split']=='Train'].groupby(by=['Store','IsHoliday'])['Weekly_Sales'].median()}).reset_index()
#medians.head()
#medians.tail()
print(medians)


# Making a bar plot of holidays vs. non-holidays and how this affects median sales
holiday = medians.loc[medians['IsHoliday'] == True]
print(holiday)
nonholiday = medians.loc[medians['IsHoliday'] == False]
print(nonholiday)
df = pd.DataFrame({'Holiday': holiday["Median Sales"], 'Non-Holiday': nonholiday["Median Sales"]})
df = df.set_index(medians["Store"])
ax = df.plot.bar(rot=0, figsize=(20,10))
print(ax)

# Making another bar plot that shows the mean of the median sales on holidays vs. non-holidays
holiday_mean = np.mean(holiday["Median Sales"])
print(holiday_mean)
nonholiday_mean = np.mean(nonholiday["Median Sales"])
print(nonholiday_mean)
plot2 = pd.Series({'Holiday': holiday_mean, 'Non_Holiday': nonholiday_mean})
print(plot2.plot(kind = "bar", colormap = "Paired"))

# Making scatterplots to visualize how certain variables affect weekly sales
scatter1 = merge.plot.scatter(x = "Fuel_Price", y = "Weekly_Sales")
print(scatter1)
scatter2 = merge.plot.scatter(x = "Temperature", y = "Weekly_Sales")
print(scatter2)
scatter3 = merge.plot.scatter(x = "CPI", y = "Weekly_Sales")
print(scatter3)
scatter4 = merge.plot.scatter(x = "Unemployment", y = "Weekly_Sales")
print(scatter4)






#df_monthly.plot.scatter(x=df_monthly["Store", y=df_monthly["Monthly_Sales"], s=df_monthly["Size"], c="red", alpha=0.4)

#temp_month = plt.scatter(y=merge["Temperature"], x = merge["month_year"])






