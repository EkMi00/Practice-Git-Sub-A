# %%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# %%
a = [1, 2, 3, 4, 5, 6, 7, 8, 9]
a

# %%
np_a = np.array(a)
print(np_a.shape)
np_a

# %%
np_a = np_a.reshape(-1, 3)
print(np_a.shape)
np_a

# %%
df = pd.read_csv("data/Marketing-train.csv", sep=';')
df

# %%
df[['age', 'job', 'marital']]

# %%
df.loc[5:9, ['age', 'job']]

# %%
# print(df[['balance']])
# df[['balance']].apply(lambda x : x/max(x))

# %%
# pd.DataFrame({"Step": [1, 2, 3], "Value": [0.5, 8.2, 7.3]})

# %%
df[['balance']].plot()

# %%
plt.figure(figsize=(14,7))
plt.title('Balance')
plt.xlabel('Row')
plt.ylabel('Balance (USD$)')
plt.plot(df.loc[:1000, ['balance']], label='balance')
plt.plot(df.loc[:1000, ['duration']], label='duration')
plt.legend()
plt.show()


