from flask import Flask, jsonify
import json
from datetime import datetime

app = Flask(__name__)

@app.route("/")
def get_data():
    try:
        with open("scraped_data.json", "r") as f:
            data = json.load(f)
        return jsonify({
            "status": "success",
            "data": data,
            "served_at": datetime.utcnow().isoformat()
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@app.route("/health")
def health_check():
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)