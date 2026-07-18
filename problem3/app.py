from flask import Flask, request, jsonify

app = Flask(__name__)

# Default status stored in memory
current_status = "OK"

@app.route('/api/v1/status', methods=['GET', 'POST'])
def status_endpoint():
    global current_status
   
    if request.method == 'POST':
        data = request.get_json(silent=True) or {}
        if 'status' in data:
            current_status = data['status']
            return jsonify({"status": current_status}), 201
        return jsonify({"error": "Invalid body. 'status' key required."}), 400

    # GET method
    return jsonify({"status": current_status}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
