from flask import Blueprint, request
from database import get_conn
from utils.responses import success, error

bp = Blueprint("cuidadores", __name__, url_prefix="/api/cuidadores")

@bp.get("/")
def listar():
    verificado = request.args.get("verificado")
    sql = """
        SELECT usuario_id, valor_hora, raio_atendimento_km, verificado,
               nota_media, total_avaliacoes, disponivel
        FROM cuidadores
    """
    params = []

    if verificado is not None:
        sql += " WHERE verificado = %s"
        params.append(verificado.lower() in ("true", "1", "t"))

    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(sql, tuple(params))
        rows = cur.fetchall()

    return success(rows)
