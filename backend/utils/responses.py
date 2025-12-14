from flask import jsonify

def success(data=None, message="OK", status=200):
    return jsonify({"success": True, "message": message, "data": data}), status

def error(message="Erro", status=400):
    return jsonify({"success": False, "error": message}), status
