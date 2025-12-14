from flask import Blueprint, request
from database import get_conn
from utils.responses import success, error

bp = Blueprint("avaliacoes", __name__, url_prefix="/api/avaliacoes")

@bp.post("/")
def avaliar():
    data = request.get_json()
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                SELECT fn_inserir_avaliacao_e_recalcular(%s,%s,%s)
            """, (
                data["agendamento_id"],
                data["nota"],
                data.get("comentario")
            ))
        return success(message="Avaliação registrada", status=201)
    except Exception as e:
        return error(str(e))
