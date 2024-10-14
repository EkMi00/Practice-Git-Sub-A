import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.impute import SimpleImputer

def preprocess_data():
    df = pd.read_csv('data/Hotel.csv')
    
    # Separate numeric and categorical columns
    numeric_columns = df.select_dtypes(include=[np.number]).columns
    categorical_columns = df.select_dtypes(exclude=[np.number]).columns
    
    # Handle missing values for numeric columns
    numeric_imputer = SimpleImputer(strategy='mean')
    df[numeric_columns] = numeric_imputer.fit_transform(df[numeric_columns])
    
    # Handle missing values for categorical columns
    categorical_imputer = SimpleImputer(strategy='most_frequent')
    df[categorical_columns] = categorical_imputer.fit_transform(df[categorical_columns])
    
    # Encode categorical variables
    df_encoded = pd.get_dummies(df, columns=[col for col in categorical_columns if col not in ['ID', 'status']])
    
    # Split features and target
    X = df_encoded.drop(['ID', 'status'], axis=1)
    y = df_encoded['status'].map({'Canceled': 1, 'Not_Canceled': 0})
    
    # Scale features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    
    return X_scaled, y, scaler, X.columns

if __name__ == "__main__":
    preprocess_data()