# %%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# %%
a = [1, 2, 3]
a

# %%
np_a = np.array(a)
print(np_a.shape)
np_a.shape # no brackets

# %%
np_a = np_a.reshape(-1, 1) # add 1 to the column index
np_a.shape
np_a

# %%
df = pd.read_csv("data/Marketing-train.csv", sep = ";")
df

# %%
df[['age', 'job', 'marital']]

# %%
df.loc[5:9, ['age', 'job']]

# %%
#print(df[['balance']])
df[['balance']].apply(lambda x : x/max(x))

# %%
pd.DataFrame({"Step":[1, 2, 3],
              "Value":[0.5, 8.2, 7.3]})

# %%
# pd's default plot
df[['balance']].plot()

# %%
plt.figure(figsize=(14, 7))
plt.title("Balance")
plt.xlabel("Row")
plt.ylabel("Balance (USD)")
plt.plot(df.loc[:1000, ['balance']], label = "balance")
plt.plot(df.loc[:1000, ['duration']], label = "duration")
plt.legend()
plt.show() # the python will actually look the GUI


