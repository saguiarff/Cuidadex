import os
from dotenv import load_dotenv
from flask import Flask, request, jsonify
from flask_cors import CORS
import psycopg
from psycopg.rows import dict_row

load_dotenv()

DB = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": os.getenv("DB_PORT", 5432),
    "dbname": os.getenv("DB_NAME"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
}

app = Flask(__name__)
CORS(app)

def get_conn():
    # psycopg 3 connection, row factory returns dicts
    return psycopg.connect(
        host=DB["host"],
        port=DB["port"],
        dbname=DB["dbname"],
        user=DB["user"],
        password=DB["password"],
        row_factory=dict_row
    )

@app.get("/")
def home():
    return jsonify({"status": "Cuidadex API rodando"})

# exemplo: listar tipos_cuidado
@app.get("/api/tipos_cuidado")
def list_tipos():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, nome, descricao FROM tipos_cuidado ORDER BY nome")
            rows = cur.fetchall()
    return jsonify(rows)

# exemplo: criar agendamento usando stored procedure sp_criar_agendamento
@app.post("/api/agendamentos")
def criar_agendamento():
    data = request.get_json()
    try:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT sp_criar_agendamento(%s,%s,%s,%s,%s,%s) AS id",
                    (
                        data["cliente_id"],
                        data["cuidador_id"],
                        data["tipo_cuidado_id"],
                        data["data_inicio"],
                        data["data_fim"],
                        data["valor_total"],
                    )
                )
                row = cur.fetchone()
        return jsonify({"id": row["id"]}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == "__main__":
    app.run(debug=True)
