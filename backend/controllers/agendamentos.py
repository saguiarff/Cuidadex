from flask import Blueprint, request
from database import get_conn
from utils.responses import success, error

bp = Blueprint("agendamentos", __name__, url_prefix="/api/agendamentos")

@bp.post("/")
def criar_agendamento():
    data = request.get_json()
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                SELECT sp_criar_agendamento(%s,%s,%s,%s,%s,%s) AS id
            """, (
                data["cliente_id"],
                data["cuidador_id"],
                data["tipo_cuidado_id"],
                data["data_inicio"],
                data["data_fim"],
                data["valor_total"]
            ))
            new_id = cur.fetchone()["id"]
        return success({"id": new_id}, "Agendamento criado", 201)
    except Exception as e:
        return error(str(e))
