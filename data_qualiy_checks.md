### Importing the essential libraries


```python
import pandas as pd
import numpy as np
import io
import json
import gzip
import datetime
import warnings
warnings.filterwarnings('ignore')
pd.options.display.float_format = '{:.2f}'.format
```

### Extracting and loading data from zip files.


```python
with gzip.open('E:/brands.json.gz', 'r') as f:
        with io.TextIOWrapper(f, encoding='utf-8') as decoder:
            data_brands = [json.loads(line) for line in decoder.readlines()]
brands = pd.json_normalize(data_brands, sep = '-')

with gzip.open('E:/users.json.gz', 'r') as f:
        with io.TextIOWrapper(f, encoding='utf-8') as decoder:
            data_user = [json.loads(line) for line in decoder.readlines()]
user = pd.json_normalize(data_user, sep = '-')

with gzip.open('E:/receipts.json.gz', 'r') as f:
        with io.TextIOWrapper(f, encoding='utf-8') as decoder:
            data_receipts = [json.loads(line) for line in decoder.readlines()]
receipts = pd.json_normalize(data_receipts, sep = '-')
```

### Exploring Brands dataset


```python
print(brands.info())
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 1167 entries, 0 to 1166
    Data columns (total 9 columns):
     #   Column        Non-Null Count  Dtype 
    ---  ------        --------------  ----- 
     0   barcode       1167 non-null   object
     1   category      1012 non-null   object
     2   categoryCode  517 non-null    object
     3   name          1167 non-null   object
     4   topBrand      555 non-null    object
     5   _id-$oid      1167 non-null   object
     6   cpg-$id-$oid  1167 non-null   object
     7   cpg-$ref      1167 non-null   object
     8   brandCode     933 non-null    object
    dtypes: object(9)
    memory usage: 82.2+ KB
    None
    

From the info, we can infer that the dimensional data has missing values. Let us investigate further to find out the proportion of missing values in the data set.


```python
brands.isnull().mean()
```




    barcode        0.00
    category       0.13
    categoryCode   0.56
    name           0.00
    topBrand       0.52
    _id-$oid       0.00
    cpg-$id-$oid   0.00
    cpg-$ref       0.00
    brandCode      0.20
    dtype: float64



`CategoryCode` and `Topbrand` columns seems to have higher missing values with proportion of 56% and 52% respecitvely

#### Summary statistics of Brands dataset


```python
print(brands.describe())
print('\n')
print('----------------------------')
print(brands.head())
```

                 barcode category categoryCode     name topBrand  \
    count           1167     1012          517     1167      555   
    unique          1160       23           14     1156        2   
    top     511111305125   Baking       BAKING  Huggies    False   
    freq               2      369          359        2      524   
    
                            _id-$oid              cpg-$id-$oid cpg-$ref brandCode  
    count                       1167                      1167     1167       933  
    unique                      1167                       196        2       897  
    top     601ac115be37ce2ead437551  559c2234e4b06aca36af13c6     Cogs            
    freq                           1                        98     1020        35  
    
    
    ----------------------------
            barcode        category      categoryCode                       name  \
    0  511111019862          Baking            BAKING  test brand @1612366101024   
    1  511111519928       Beverages         BEVERAGES                  Starbucks   
    2  511111819905          Baking            BAKING  test brand @1612366146176   
    3  511111519874          Baking            BAKING  test brand @1612366146051   
    4  511111319917  Candy & Sweets  CANDY_AND_SWEETS  test brand @1612366146827   
    
      topBrand                  _id-$oid              cpg-$id-$oid cpg-$ref  \
    0    False  601ac115be37ce2ead437551  601ac114be37ce2ead437550     Cogs   
    1    False  601c5460be37ce2ead43755f  5332f5fbe4b03c9a25efd0ba     Cogs   
    2    False  601ac142be37ce2ead43755d  601ac142be37ce2ead437559     Cogs   
    3    False  601ac142be37ce2ead43755a  601ac142be37ce2ead437559     Cogs   
    4    False  601ac142be37ce2ead43755e  5332fa12e4b03c9a25efd1e7     Cogs   
    
                           brandCode  
    0                            NaN  
    1                      STARBUCKS  
    2  TEST BRANDCODE @1612366146176  
    3  TEST BRANDCODE @1612366146051  
    4  TEST BRANDCODE @1612366146827  
    

While `CategoryCode` has 14 unique values and `category` has 23 unique values, let's find out the levels in each columns


```python
print(brands.category.unique())
print('-------------------------------------------')
print('\n')
print(brands.categoryCode.unique())
print('-------------------------------------------')
print('\n')
# To find out the frequecy and unqiue occurence of 'Category' and 'CategoryCode'  
print(brands.groupby(['category', 'categoryCode']).size().reset_index(name='Count'))
```

    ['Baking' 'Beverages' 'Candy & Sweets' 'Condiments & Sauces'
     'Canned Goods & Soups' nan 'Magazines' 'Breakfast & Cereal'
     'Beer Wine Spirits' 'Health & Wellness' 'Beauty' 'Baby' 'Frozen'
     'Grocery' 'Snacks' 'Household' 'Personal Care' 'Dairy'
     'Cleaning & Home Improvement' 'Deli' 'Beauty & Personal Care'
     'Bread & Bakery' 'Outdoor' 'Dairy & Refrigerated']
    -------------------------------------------
    
    
    ['BAKING' 'BEVERAGES' 'CANDY_AND_SWEETS' nan 'HEALTHY_AND_WELLNESS'
     'GROCERY' 'PERSONAL_CARE' 'CLEANING_AND_HOME_IMPROVEMENT'
     'BEER_WINE_SPIRITS' 'BABY' 'BREAD_AND_BAKERY' 'OUTDOOR'
     'DAIRY_AND_REFRIGERATED' 'MAGAZINES' 'FROZEN']
    -------------------------------------------
    
    
                           category                   categoryCode  Count
    0                          Baby                           BABY      7
    1                        Baking                         BAKING    359
    2             Beer Wine Spirits              BEER_WINE_SPIRITS     31
    3                     Beverages                      BEVERAGES      1
    4                Bread & Bakery               BREAD_AND_BAKERY      5
    5                Candy & Sweets               CANDY_AND_SWEETS     71
    6   Cleaning & Home Improvement  CLEANING_AND_HOME_IMPROVEMENT      6
    7          Dairy & Refrigerated         DAIRY_AND_REFRIGERATED      5
    8                        Frozen                         FROZEN      1
    9                       Grocery                        GROCERY     11
    10            Health & Wellness           HEALTHY_AND_WELLNESS     14
    11                    Magazines                      MAGAZINES      1
    12                      Outdoor                        OUTDOOR      1
    13                Personal Care                  PERSONAL_CARE      4
    

As we know there are 14 unique category codes mapped to corresponding category, there are transactions present for 14 category of items. Hence we need to find out the categories with missing category code


```python
{
    str(i).lower().replace(' ', '_').replace('&', 'and')
    for i in brands.category.unique()
} ^ {str(i).lower()
     for i in brands.categoryCode.unique()}
```




    {'beauty',
     'beauty_and_personal_care',
     'breakfast_and_cereal',
     'canned_goods_and_soups',
     'condiments_and_sauces',
     'dairy',
     'deli',
     'health_and_wellness',
     'healthy_and_wellness',
     'household',
     'snacks'}



Here we can see that few category products either should be mapped to related categorycode for example, 'beauty' and 'beauty_and_personal' categories can be mapped to 'PERSONAL_CARE' or categorycode should be updated with missing category with same format as follows. 

***Data Quality Issues in Brand Dataset:***
Upon exploring the dataset, the data quality issues addressed are,
- finding the columns with high proportion of missing values 
- refactoring the `categoryCode` column. 

### Exploring Users dataset


```python
print(user.info())
print('----------------------------------------------')
print('\n')
print(user.isnull().mean())
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 495 entries, 0 to 494
    Data columns (total 7 columns):
     #   Column             Non-Null Count  Dtype  
    ---  ------             --------------  -----  
     0   active             495 non-null    bool   
     1   role               495 non-null    object 
     2   signUpSource       447 non-null    object 
     3   state              439 non-null    object 
     4   _id-$oid           495 non-null    object 
     5   createdDate-$date  495 non-null    int64  
     6   lastLogin-$date    433 non-null    float64
    dtypes: bool(1), float64(1), int64(1), object(4)
    memory usage: 23.8+ KB
    None
    ----------------------------------------------
    
    
    active              0.00
    role                0.00
    signUpSource        0.10
    state               0.11
    _id-$oid            0.00
    createdDate-$date   0.00
    lastLogin-$date     0.13
    dtype: float64
    

There are high missing values in `lastlogin` and `state` columns. `CreatedDate` and 'lastlogin' columns are in incorrect data type. 

#### Summary Statistics of Users data


```python
# Treating the incorrect data type to Date format
user['createdDate-$date'] = user['createdDate-$date'].apply(
    lambda x: datetime.datetime.fromtimestamp(x / 1000))
user['lastLogin-$date'] = user['lastLogin-$date'].apply(
    lambda x: datetime.datetime.fromtimestamp(x / 1000) if x.is_integer() else np.nan)
print('\n')
print('----------------------------')
print(user.describe())
```

    
    
    ----------------------------
           active      role signUpSource state                  _id-$oid  \
    count     495       495          447   439                       495   
    unique      2         2            2     8                       212   
    top      True  consumer        Email    WI  54943462e4b07e684157a532   
    freq      494       413          443   396                        20   
    first     NaN       NaN          NaN   NaN                       NaN   
    last      NaN       NaN          NaN   NaN                       NaN   
    
                     createdDate-$date             lastLogin-$date  
    count                          495                         433  
    unique                         212                         172  
    top     2014-12-19 06:21:22.381000  2021-03-05 08:52:23.204000  
    freq                            20                          20  
    first   2014-12-19 06:21:22.381000  2018-05-07 10:23:40.003000  
    last    2021-02-12 06:11:06.240000  2021-03-05 08:52:23.204000  
    


```python
print(user.head())
```

       active      role signUpSource state                  _id-$oid  \
    0    True  consumer        Email    WI  5ff1e194b6a9d73a3a9f1052   
    1    True  consumer        Email    WI  5ff1e194b6a9d73a3a9f1052   
    2    True  consumer        Email    WI  5ff1e194b6a9d73a3a9f1052   
    3    True  consumer        Email    WI  5ff1e1eacfcf6c399c274ae6   
    4    True  consumer        Email    WI  5ff1e194b6a9d73a3a9f1052   
    
            createdDate-$date         lastLogin-$date  
    0 2021-01-03 07:24:04.800 2021-01-03 07:25:37.858  
    1 2021-01-03 07:24:04.800 2021-01-03 07:25:37.858  
    2 2021-01-03 07:24:04.800 2021-01-03 07:25:37.858  
    3 2021-01-03 07:25:30.554 2021-01-03 07:25:30.597  
    4 2021-01-03 07:24:04.800 2021-01-03 07:25:37.858  
    

From summary statistics, we can infer:
- there are 495 users data and there are only 212 unique userID which implies there are few users duplicated. 
- Out of 495 users, 443 users signed up through 'Email'
- Most of the users are based out in WI, (396/495)


```python
print(user.role.unique())
print('-----------------------------')
print(user.signUpSource.unique())
print('-----------------------------')
print(user.state.unique())
```

    ['consumer' 'fetch-staff']
    -----------------------------
    ['Email' 'Google' nan]
    -----------------------------
    ['WI' 'KY' 'AL' 'CO' 'IL' nan 'OH' 'SC' 'NH']
    


```python
# Ignoring the duplicate users
print(user[~user.duplicated()].describe())
```

           active      role signUpSource state                  _id-$oid  \
    count     212       212          207   206                       212   
    unique      2         2            2     8                       212   
    top      True  consumer        Email    WI  5ff1e194b6a9d73a3a9f1052   
    freq      211       204          204   193                         1   
    first     NaN       NaN          NaN   NaN                       NaN   
    last      NaN       NaN          NaN   NaN                       NaN   
    
                     createdDate-$date             lastLogin-$date  
    count                          212                         172  
    unique                         212                         172  
    top     2021-01-03 07:24:04.800000  2021-01-03 07:25:37.858000  
    freq                             1                           1  
    first   2014-12-19 06:21:22.381000  2018-05-07 10:23:40.003000  
    last    2021-02-12 06:11:06.240000  2021-03-05 08:52:23.204000  
    

Characteristics of data has remained same. Lets explore the number of users across each state and signupsource


```python
print(user[~user.duplicated()].groupby([
    'state', 'signUpSource'
]).size().reset_index(name='count').sort_values('count', ascending=False))
```

      state signUpSource  count
    8    WI        Email    190
    0    AL        Email      3
    1    AL       Google      2
    3    IL        Email      2
    2    CO        Email      1
    4    KY        Email      1
    5    NH        Email      1
    6    OH        Email      1
    7    SC        Email      1
    9    WI       Google      1
    

***Data Quality Issues in User Dataset:***
Upon exploring the dataset, the data quality issues addressed are,
- finding the columns with high proportion of missing values and duplicate users 
- changing the incorrect datetype of date columns to 'datetime' datatype 

### Exploring Receipt Dataset


```python
print(receipts.info())
print('-------------------------------------------')
print('\n')
print(receipts.isnull().mean().sort_values(ascending=False))
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 1119 entries, 0 to 1118
    Data columns (total 15 columns):
     #   Column                   Non-Null Count  Dtype  
    ---  ------                   --------------  -----  
     0   bonusPointsEarned        544 non-null    float64
     1   bonusPointsEarnedReason  544 non-null    object 
     2   pointsEarned             609 non-null    object 
     3   purchasedItemCount       635 non-null    float64
     4   rewardsReceiptItemList   679 non-null    object 
     5   rewardsReceiptStatus     1119 non-null   object 
     6   totalSpent               684 non-null    object 
     7   userId                   1119 non-null   object 
     8   _id-$oid                 1119 non-null   object 
     9   createDate-$date         1119 non-null   int64  
     10  dateScanned-$date        1119 non-null   int64  
     11  finishedDate-$date       568 non-null    float64
     12  modifyDate-$date         1119 non-null   int64  
     13  pointsAwardedDate-$date  537 non-null    float64
     14  purchaseDate-$date       671 non-null    float64
    dtypes: float64(5), int64(3), object(7)
    memory usage: 131.3+ KB
    None
    -------------------------------------------
    
    
    pointsAwardedDate-$date   0.52
    bonusPointsEarned         0.51
    bonusPointsEarnedReason   0.51
    finishedDate-$date        0.49
    pointsEarned              0.46
    purchasedItemCount        0.43
    purchaseDate-$date        0.40
    rewardsReceiptItemList    0.39
    totalSpent                0.39
    rewardsReceiptStatus      0.00
    userId                    0.00
    _id-$oid                  0.00
    createDate-$date          0.00
    dateScanned-$date         0.00
    modifyDate-$date          0.00
    dtype: float64
    

From the data description, we can found that there are 1119 unique user data. Hence there are no duplicate records.


```python
print(receipts.head())
```

       bonusPointsEarned                            bonusPointsEarnedReason  \
    0             500.00  Receipt number 2 completed, bonus point schedu...   
    1             150.00  Receipt number 5 completed, bonus point schedu...   
    2               5.00                         All-receipts receipt bonus   
    3               5.00                         All-receipts receipt bonus   
    4               5.00                         All-receipts receipt bonus   
    
      pointsEarned  purchasedItemCount  \
    0        500.0                5.00   
    1        150.0                2.00   
    2            5                1.00   
    3          5.0                4.00   
    4          5.0                2.00   
    
                                  rewardsReceiptItemList rewardsReceiptStatus  \
    0  [{'barcode': '4011', 'description': 'ITEM NOT ...             FINISHED   
    1  [{'barcode': '4011', 'description': 'ITEM NOT ...             FINISHED   
    2  [{'needsFetchReview': False, 'partnerItemId': ...             REJECTED   
    3  [{'barcode': '4011', 'description': 'ITEM NOT ...             FINISHED   
    4  [{'barcode': '4011', 'description': 'ITEM NOT ...             FINISHED   
    
      totalSpent                    userId                  _id-$oid  \
    0      26.00  5ff1e1eacfcf6c399c274ae6  5ff1e1eb0a720f0523000575   
    1      11.00  5ff1e194b6a9d73a3a9f1052  5ff1e1bb0a720f052300056b   
    2      10.00  5ff1e1f1cfcf6c399c274b0b  5ff1e1f10a720f052300057a   
    3      28.00  5ff1e1eacfcf6c399c274ae6  5ff1e1ee0a7214ada100056f   
    4       1.00  5ff1e194b6a9d73a3a9f1052  5ff1e1d20a7214ada1000561   
    
       createDate-$date  dateScanned-$date  finishedDate-$date  modifyDate-$date  \
    0     1609687531000      1609687531000    1609687531000.00     1609687536000   
    1     1609687483000      1609687483000    1609687483000.00     1609687488000   
    2     1609687537000      1609687537000                 NaN     1609687542000   
    3     1609687534000      1609687534000    1609687534000.00     1609687539000   
    4     1609687506000      1609687506000    1609687511000.00     1609687511000   
    
       pointsAwardedDate-$date  purchaseDate-$date  
    0         1609687531000.00    1609632000000.00  
    1         1609687483000.00    1609601083000.00  
    2                      NaN    1609632000000.00  
    3         1609687534000.00    1609632000000.00  
    4         1609687506000.00    1609601106000.00  
    

By inspecting the data, column `rewardsReceiptItemLis` list of dict data type. Hence we should convert the dict values to dataframe.


```python
receipts_explode = receipts.explode('rewardsReceiptItemList')
receipts_explode.reset_index(drop=True, inplace=True)

items = pd.json_normalize(receipts_explode.rewardsReceiptItemList)
receipts_explode.drop(columns='rewardsReceiptItemList', inplace=True)
receipts_final = pd.concat([receipts_explode, items], axis = 1)
```


```python
receipts_final.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 7381 entries, 0 to 7380
    Data columns (total 48 columns):
     #   Column                              Non-Null Count  Dtype  
    ---  ------                              --------------  -----  
     0   bonusPointsEarned                   5980 non-null   float64
     1   bonusPointsEarnedReason             5980 non-null   object 
     2   pointsEarned                        6253 non-null   object 
     3   purchasedItemCount                  6897 non-null   float64
     4   rewardsReceiptStatus                7381 non-null   object 
     5   totalSpent                          6946 non-null   object 
     6   userId                              7381 non-null   object 
     7   _id-$oid                            7381 non-null   object 
     8   createDate-$date                    7381 non-null   int64  
     9   dateScanned-$date                   7381 non-null   int64  
     10  finishedDate-$date                  5970 non-null   float64
     11  modifyDate-$date                    7381 non-null   int64  
     12  pointsAwardedDate-$date             6080 non-null   float64
     13  purchaseDate-$date                  6923 non-null   float64
     14  barcode                             3090 non-null   object 
     15  description                         6560 non-null   object 
     16  finalPrice                          6767 non-null   object 
     17  itemPrice                           6767 non-null   object 
     18  needsFetchReview                    813 non-null    object 
     19  partnerItemId                       6941 non-null   object 
     20  preventTargetGapPoints              358 non-null    object 
     21  quantityPurchased                   6767 non-null   float64
     22  userFlaggedBarcode                  337 non-null    object 
     23  userFlaggedNewItem                  323 non-null    object 
     24  userFlaggedPrice                    299 non-null    object 
     25  userFlaggedQuantity                 299 non-null    float64
     26  needsFetchReviewReason              219 non-null    object 
     27  pointsNotAwardedReason              340 non-null    object 
     28  pointsPayerId                       1267 non-null   object 
     29  rewardsGroup                        1731 non-null   object 
     30  rewardsProductPartnerId             2269 non-null   object 
     31  userFlaggedDescription              205 non-null    object 
     32  originalMetaBriteBarcode            71 non-null     object 
     33  originalMetaBriteDescription        10 non-null     object 
     34  brandCode                           2600 non-null   object 
     35  competitorRewardsGroup              275 non-null    object 
     36  discountedItemPrice                 5769 non-null   object 
     37  originalReceiptItemText             5760 non-null   object 
     38  itemNumber                          153 non-null    object 
     39  originalMetaBriteQuantityPurchased  15 non-null     float64
     40  pointsEarned                        927 non-null    object 
     41  targetPrice                         378 non-null    object 
     42  competitiveProduct                  645 non-null    object 
     43  originalFinalPrice                  9 non-null      object 
     44  originalMetaBriteItemPrice          9 non-null      object 
     45  deleted                             9 non-null      object 
     46  priceAfterCoupon                    956 non-null    object 
     47  metabriteCampaignId                 863 non-null    object 
    dtypes: float64(8), int64(3), object(37)
    memory usage: 2.7+ MB
    


```python
# Treating the incorrect data type to Date format
for i in ['createDate-$date', 'dateScanned-$date', 'modifyDate-$date']:
    receipts_final[i] = receipts_final[i].apply(
        lambda x: datetime.datetime.fromtimestamp(x / 1000))
for i in ['finishedDate-$date', 'pointsAwardedDate-$date', 'purchaseDate-$date']:
    receipts_final[i] = receipts_final[i].apply(
        lambda x: datetime.datetime.fromtimestamp(x / 1000) if x.is_integer() else np.nan)

# Treating the inncorrect data tyoe of numeric fields
receipts_final['pointsEarned'] = receipts_final['pointsEarned'].astype('float')
receipts_final['totalSpent'] = receipts_final['totalSpent'].astype('float')
receipts_final['finalPrice'] = receipts_final['finalPrice'].astype('float')
receipts_final['itemPrice'] = receipts_final['itemPrice'].astype('float')
receipts_final['quantityPurchased'] = receipts_final['quantityPurchased'].astype('float')
```

#### Summary Statistics


```python
print('----------------------------')
print('\n')
print(receipts_final.describe(include='O'))
print('----------------------------')
print('\n')

```

    ----------------------------
    
    
                                      bonusPointsEarnedReason  \
    count                                                5980   
    unique                                                  9   
    top     Receipt number 1 completed, bonus point schedu...   
    freq                                                 4605   
    
           rewardsReceiptStatus                    userId  \
    count                  7381                      7381   
    unique                    5                       258   
    top                FINISHED  5fc961c3b8cfca11a077dd33   
    freq                   5920                       477   
    
                            _id-$oid barcode     description needsFetchReview  \
    count                       7381    3090            6560              813   
    unique                      1119     568            1889                2   
    top     600f2fc80a720f0535000030    4011  ITEM NOT FOUND            False   
    freq                         459     177             173              594   
    
           partnerItemId preventTargetGapPoints userFlaggedBarcode  ...  \
    count           6941                    358                337  ...   
    unique           916                      1                  6  ...   
    top                1                   True       034100573065  ...   
    freq             531                    358                166  ...   
    
           discountedItemPrice  originalReceiptItemText itemNumber targetPrice  \
    count                 5769                     5760        153         378   
    unique                 817                     1738         47           2   
    top                   3.99  KLARBRUNN 12PK 12 FL OZ       4023         800   
    freq                   243                      120         92         299   
    
           competitiveProduct originalFinalPrice originalMetaBriteItemPrice  \
    count                 645                  9                          9   
    unique                  2                  2                          2   
    top                  True               1.00                       1.00   
    freq                  468                  6                          6   
    
           deleted priceAfterCoupon       metabriteCampaignId  
    count        9              956                       863  
    unique       1              334                        75  
    top       True            28.57  BEN AND JERRYS ICE CREAM  
    freq         9               50                       180  
    
    [4 rows x 32 columns]
    ----------------------------
    
    
    


```python
print(receipts_final.describe(exclude='O', datetime_is_numeric=True))
```

           bonusPointsEarned  pointsEarned  purchasedItemCount  totalSpent  \
    count            5980.00       6253.00             6897.00     6946.00   
    mean              625.90       2175.58              240.76     1368.58   
    min                 5.00          0.00                0.00        0.00   
    25%               750.00        750.00               93.00      373.55   
    50%               750.00       1447.00              167.00      776.79   
    75%               750.00       2685.80              335.00     1183.10   
    max               750.00      10199.80              689.00     4721.95   
    std               244.40       2175.73              221.81     1588.96   
    
                        createDate-$date              dateScanned-$date  \
    count                           7381                           7381   
    mean   2021-01-21 11:52:10.887508992  2021-01-21 11:52:10.887508992   
    min              2020-10-30 13:17:59            2020-10-30 13:17:59   
    25%              2021-01-16 15:14:56            2021-01-16 15:14:56   
    50%              2021-01-22 08:07:11            2021-01-22 08:07:11   
    75%              2021-01-25 12:05:43            2021-01-25 12:05:43   
    max       2021-03-01 15:17:34.772000     2021-03-01 15:17:34.772000   
    std                              NaN                            NaN   
    
                      finishedDate-$date               modifyDate-$date  \
    count                           5970                           7381   
    mean   2021-01-20 10:47:58.447184896  2021-01-22 09:38:52.782238976   
    min              2021-01-03 07:24:10            2021-01-03 07:24:10   
    25%              2021-01-16 15:09:03            2021-01-16 15:31:40   
    50%              2021-01-21 16:30:13            2021-01-22 08:32:00   
    75%              2021-01-25 06:51:04            2021-01-25 14:39:03   
    max              2021-02-26 14:36:25     2021-03-01 15:17:34.772000   
    std                              NaN                            NaN   
    
                 pointsAwardedDate-$date             purchaseDate-$date  \
    count                           6080                           6923   
    mean   2021-01-19 18:22:05.249013248  2021-01-12 04:46:27.671674112   
    min              2020-10-30 13:18:00            2017-10-29 17:00:00   
    25%              2021-01-15 19:47:26            2021-01-12 08:09:22   
    50%       2021-01-21 13:44:11.500000            2021-01-20 16:00:00   
    75%              2021-01-25 06:51:04            2021-01-23 16:00:00   
    max              2021-02-26 14:36:25            2021-03-08 09:37:13   
    std                              NaN                            NaN   
    
           finalPrice  itemPrice  quantityPurchased  userFlaggedQuantity  \
    count     6767.00    6767.00            6767.00               299.00   
    mean         7.87       7.87               1.39                 1.87   
    min          0.00       0.00               1.00                 1.00   
    25%          2.29       2.29               1.00                 1.00   
    50%          4.28       4.28               1.00                 1.00   
    75%          9.99       9.99               1.00                 3.00   
    max        441.58     441.58              17.00                 5.00   
    std         14.66      14.66               1.20                 1.31   
    
           originalMetaBriteQuantityPurchased  pointsEarned  
    count                               15.00        927.00  
    mean                                 1.20        140.51  
    min                                  1.00          4.50  
    25%                                  1.00         28.05  
    50%                                  1.00         50.00  
    75%                                  1.00        165.45  
    max                                  2.00        870.00  
    std                                  0.41        223.01  
    


```python
print(receipts_final.head())
```

       bonusPointsEarned                            bonusPointsEarnedReason  \
    0             500.00  Receipt number 2 completed, bonus point schedu...   
    1             150.00  Receipt number 5 completed, bonus point schedu...   
    2             150.00  Receipt number 5 completed, bonus point schedu...   
    3               5.00                         All-receipts receipt bonus   
    4               5.00                         All-receipts receipt bonus   
    
      pointsEarned  purchasedItemCount rewardsReceiptStatus  totalSpent  \
    0       500.00                5.00             FINISHED       26.00   
    1       150.00                2.00             FINISHED       11.00   
    2       150.00                2.00             FINISHED       11.00   
    3         5.00                1.00             REJECTED       10.00   
    4         5.00                4.00             FINISHED       28.00   
    
                         userId                  _id-$oid    createDate-$date  \
    0  5ff1e1eacfcf6c399c274ae6  5ff1e1eb0a720f0523000575 2021-01-03 07:25:31   
    1  5ff1e194b6a9d73a3a9f1052  5ff1e1bb0a720f052300056b 2021-01-03 07:24:43   
    2  5ff1e194b6a9d73a3a9f1052  5ff1e1bb0a720f052300056b 2021-01-03 07:24:43   
    3  5ff1e1f1cfcf6c399c274b0b  5ff1e1f10a720f052300057a 2021-01-03 07:25:37   
    4  5ff1e1eacfcf6c399c274ae6  5ff1e1ee0a7214ada100056f 2021-01-03 07:25:34   
    
        dateScanned-$date  ... itemNumber originalMetaBriteQuantityPurchased  \
    0 2021-01-03 07:25:31  ...        NaN                                NaN   
    1 2021-01-03 07:24:43  ...        NaN                                NaN   
    2 2021-01-03 07:24:43  ...        NaN                                NaN   
    3 2021-01-03 07:25:37  ...        NaN                                NaN   
    4 2021-01-03 07:25:34  ...        NaN                                NaN   
    
      pointsEarned targetPrice competitiveProduct originalFinalPrice  \
    0          NaN         NaN                NaN                NaN   
    1          NaN         NaN                NaN                NaN   
    2          NaN         NaN                NaN                NaN   
    3          NaN         NaN                NaN                NaN   
    4          NaN         NaN                NaN                NaN   
    
       originalMetaBriteItemPrice  deleted priceAfterCoupon metabriteCampaignId  
    0                         NaN      NaN              NaN                 NaN  
    1                         NaN      NaN              NaN                 NaN  
    2                         NaN      NaN              NaN                 NaN  
    3                         NaN      NaN              NaN                 NaN  
    4                         NaN      NaN              NaN                 NaN  
    
    [5 rows x 48 columns]
    

***Data Quality Issues:*** Upon exploring the dataset, the data quality issues addressed are,
- parsed nested json values to tabular format and concatenated to original dataset
- changed the incorrect data types of the columns to appropriate data types. ASsuming missing values are valid for those have total spend is 0 which implies no transcation made


```python

```
