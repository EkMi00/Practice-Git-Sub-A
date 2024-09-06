# %%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns



# %%
a = [1, 2, 3, 4, 5, 6]
a


# %%
np_a = np.array(a) #casts a as numpy array data type
print(np_a.shape)
print(np_a)

np_a = np_a.reshape(-1, 2) #-1 means keep the number of elements constant in the array
print(np_a.shape)
np_a

# %%
df = pd.read_csv("data/Marketing-train.csv", sep=";")
df

df[['age', 'job', 'marital']] #get columns in the dataframe

df.loc[5:9, ['age' , 'job']] # get range of rows, inclusive of indices in range

df[['balance']].apply(lambda x: x ** 2) #apply function to column in dataframe

df[['balance']].apply(lambda x: x/max(x)) 

# %%
pd.DataFrame({"Step": [1, 2, 3], "Value": [0.5, 8.2, 7.3]}) #panda dataframes are created by passing in dictionaries



# %%
#plotting

plt.figure(figsize = (14,7))
plt.title("Balance")
plt.xlabel("Entry")
plt.ylabel("Balance (USD)")
plt.plot(df.loc[:1000, ["balance"]], label = "balance")
plt.plot(df.loc[:1000, ["duration"]], label = "duration")
plt.legend()
plt.show() #must call if want to use python script

# %%
import os
os.getcwd()



