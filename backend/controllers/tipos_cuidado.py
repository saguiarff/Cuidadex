from flask import Blueprint, request
from database import get_conn
from utils.responses import success, error

bp = Blueprint("tipos_cuidado", __name__, url_prefix="/api/tipos_cuidado")

@bp.get("/")
def listar():
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute("SELECT id, nome, descricao FROM tipos_cuidado ORDER BY nome")
        rows = cur.fetchall()
    return success(rows)

@bp.post("/")
def criar():
    data = request.get_json()
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                INSERT INTO tipos_cuidado (nome, descricao)
                VALUES (%s, %s)
                RETURNING id
            """, (data["nome"], data.get("descricao")))
            new_id = cur.fetchone()["id"]
        return success({"id": new_id}, "Criado", 201)
    except Exception as e:
        return error(str(e))

@bp.put("/<int:id>")
def atualizar(id):
    data = request.get_json()
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                UPDATE tipos_cuidado
                SET nome=%s, descricao=%s
                WHERE id=%s
            """, (data["nome"], data.get("descricao"), id))
        return success(message="Atualizado")
    except Exception as e:
        return error(str(e))

@bp.delete("/<int:id>")
def deletar(id):
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("DELETE FROM tipos_cuidado WHERE id=%s", (id,))
        return success(message="Removido")
    except Exception as e:
        return error(str(e))