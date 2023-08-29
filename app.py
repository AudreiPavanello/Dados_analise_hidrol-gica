from flask import Flask, render_template, request
import joblib

app = Flask(__name__)

# Load the trained model
model = joblib.load("saved_model.joblib")

@app.route("/", methods=["GET", "POST"])
def index():
    prediction = None

    if request.method == "POST":
        # Get user input from the form
        input_data = [float(request.form["input1"]), float(request.form["input2"])]
        
        # Make prediction using the model
        prediction = model.predict([input_data])[0]

    return render_template("index.html", prediction=prediction)

if __name__ == "__main__":
    app.run(debug=True)
