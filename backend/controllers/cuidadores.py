from flask import Blueprint, request
from database import get_conn
from utils.responses import success, error

bp = Blueprint("cuidadores", __name__, url_prefix="/api/cuidadores")


@bp.get("/")
def listar():
    try:
        verificado = request.args.get("verificado")

        sql = """
            SELECT
                u.id,
                u.nome,
                u.avatar_url,
                c.bio,
                c.valor_hora,
                c.raio_atendimento_km,
                c.verificado,
                c.nota_media,
                c.total_avaliacoes,
                c.disponivel
            FROM cuidadores c
            JOIN usuarios u ON u.id = c.usuario_id
        """

        params = []

        if verificado is not None:
            sql += " WHERE c.verificado = %s"
            params.append(verificado.lower() in ("true", "1", "t"))

        sql += " ORDER BY c.nota_media DESC"

        with get_conn() as conn, conn.cursor() as cur:
            cur.execute(sql, tuple(params))
            rows = cur.fetchall()

        return success(rows)

    except Exception as e:
        return error(str(e))
