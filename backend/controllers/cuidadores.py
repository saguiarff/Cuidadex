from flask import Blueprint, request
from database import get_conn
from utils.responses import success, error

bp = Blueprint("cuidadores", __name__, url_prefix="/api/cuidadores")


# LISTAR CUIDADORES
@bp.get("")
def listar():
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                SELECT u.id, u.nome, u.avatar_url,
                       c.bio, c.valor_hora, c.raio_atendimento_km
                FROM cuidadores c
                JOIN usuarios u ON u.id = c.usuario_id
            """)
            rows = cur.fetchall()

        return success(rows)
    except Exception as e:
        return error(str(e))


# CRIAR CUIDADOR (OBRIGATÓRIO)
@bp.route("", methods=["POST", "OPTIONS"])
def criar():
    if request.method == "OPTIONS":
        return "", 200

    data = request.get_json()

    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                INSERT INTO cuidadores
                (usuario_id, bio, valor_hora, raio_atendimento_km)
                VALUES (%s, %s, %s, %s)
            """, (
                data["usuario_id"],
                data["bio"],
                data["valor_hora"],
                data["raio_km"],
            ))

        return success(message="Cuidador criado", status=201)

    except Exception as e:
        return error(str(e))