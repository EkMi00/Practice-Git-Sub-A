from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report
import joblib
from preprocess import preprocess_data
import matplotlib.pyplot as plt
import numpy as np
import os

def train_model():
    X, y, scaler, feature_names = preprocess_data()
    
    # Train a Logistic Regression model (simpler and faster than Random Forest)
    model = LogisticRegression(random_state=42, max_iter=1000)
    model.fit(X, y)
    
    # Make predictions
    y_pred = model.predict(X)
    
    # Print model performance
    print("Model Accuracy:", accuracy_score(y, y_pred))
    print("\nClassification Report:")
    print(classification_report(y, y_pred))
    
    # Feature importance plot (for Logistic Regression, we'll use the absolute values of coefficients)
    importances = np.abs(model.coef_[0])
    indices = np.argsort(importances)[::-1]
    
    plt.figure(figsize=(12,8))
    plt.title("Feature Importances")
    plt.bar(range(len(importances)), importances[indices])
    plt.xticks(range(len(importances)), [feature_names[i] for i in indices], rotation=90)
    plt.tight_layout()
    
    # Ensure the templates directory exists
    os.makedirs('templates', exist_ok=True)
    plt.savefig('templates/feature_importance.png')
    
    # Ensure the models directory exists
    os.makedirs('models', exist_ok=True)
    
    # Save the model and scaler
    joblib.dump(model, 'models/lr_model.joblib')
    joblib.dump(scaler, 'models/scaler.joblib')

if __name__ == "__main__":
    train_model()