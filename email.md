Communication to Project manager(Adam)

Hi Adam,
  As I was working on to develop a new data warehouse model for product analytics, I found few data quality issues while exploring data from new data sources namely 
receipts, users and brands. There is significant amount of data missing and inconsistencies across the data sources which will lead to gain inaccurate insights.

The following data quality issues found in the data sources:
In Brands data source, 
- categoryCode and topBrands columns have high proportion of missing values with 56% and 52% respectively.
- Inconsistency in cateory and cateogryCode mappings, there are 14 and 23 unique levels in categoryCode and category respectvely. Hence few cateogries are missing with
category Codes.
		- categoryCode: The category code that references a BrandCategory
		- category: The category name for which the brand sells products in
		- topBrands: Boolean indicator for whether the brand should be featured as a 'top brand'

In Users datasource, 
- there are 57% duplicate users present in the datasource.
- 90% of users in the datasource are signedup from email and 80% of user are only from WI.

In Receipts data source,
- One of the columns in the datasource is in nested JSON format which need to be converted to tabular format to have consistent data and correct relationship with other tables.
- More than 50% of the data is missing in few columns. However, assuming missing values are valid for those have total spend is 0, which implies no transcation made.

Date fields format is incorrect across all the datasources. Hence I standaridezed the date fileds to access dates at differnt granularity.
I designed datawarehouse in star schema for perforamance and compatibility. I have developed data validation scripts to validate the data before loading into data warehouse,
hence mitigating the risk of data inconsistency.

It is yet to be determined of how to impute missing values in the data source based on various business ues cases.
Also, want to understand how users datasource is built since there are more number of duplicates and more users only from WI state.

I would like to discuss more on the data model in detail with you, so kindly please let me know your availablity for a mneeting.

Thank you.

Best,
Vijay 
