from flask import Flask, render_template
import pandas as pd
import joblib
import os
import time
import numpy as np

app = Flask(__name__)

def load_model(retries=5, delay=10):
    for _ in range(retries):
        if os.path.exists('models/lr_model.joblib') and os.path.exists('models/scaler.joblib'):
            model = joblib.load('models/lr_model.joblib')
            scaler = joblib.load('models/scaler.joblib')
            return model, scaler
        print("Waiting for model and scaler files...")
        time.sleep(delay)
    raise FileNotFoundError("Model or scaler file not found after multiple retries")

def load_data():
    return pd.read_csv('data/Hotel.csv')

model, scaler = None, None
df = load_data()

def analyze_model():
    global model, scaler, df
    
    if model is None or scaler is None:
        try:
            model, scaler = load_model()
        except FileNotFoundError:
            return "Model is still training. Please try again later."

    # Get feature names (excluding 'ID' and 'status')
    feature_names = [col for col in df.columns if col not in ['ID', 'status']]

    # Get model coefficients
    coefficients = model.coef_[0]

    # Pair feature names with their coefficients
    feature_importance = list(zip(feature_names, coefficients))

    # Sort by absolute value of coefficient (descending)
    feature_importance.sort(key=lambda x: abs(x[1]), reverse=True)

    # Prepare the analysis results
    analysis = []
    analysis.append("Top 5 factors that predict cancellation:")
    for feature, coef in feature_importance[:5]:
        impact = "increases" if coef > 0 else "decreases"
        analysis.append(f"- {feature}: {impact} likelihood of cancellation")

    analysis.append("\nRecommendations to avoid cancellations:")
    for feature, coef in feature_importance[:5]:
        if coef > 0:
            analysis.append(f"- Reduce {feature} if possible")
        else:
            analysis.append(f"- Increase {feature} if possible")

    return "\n".join(analysis)

@app.route('/')
def index():
    analysis_result = analyze_model()
    return render_template('index.html', analysis=analysis_result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)