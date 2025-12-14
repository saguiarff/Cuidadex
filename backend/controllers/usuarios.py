from flask import Blueprint, request
from database import get_conn
from utils.responses import success, error

bp = Blueprint("usuarios", __name__, url_prefix="/api/usuarios")


# LISTAR USUÁRIOS
@bp.get("/")
def listar():
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                SELECT id, nome, email, telefone, cpf,
                       data_nascimento, tipo_usuario,
                       ativo, data_cadastro, avatar_url
                FROM usuarios
                ORDER BY nome
            """)
            rows = cur.fetchall()
        return success(rows)
    except Exception as e:
        return error(str(e))


# BUSCAR USUÁRIO POR ID

@bp.get("/<int:id>")
def buscar_por_id(id):
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                SELECT id, nome, email, telefone, cpf,
                       data_nascimento, tipo_usuario,
                       ativo, data_cadastro, avatar_url
                FROM usuarios
                WHERE id = %s
            """, (id,))
            row = cur.fetchone()

        if not row:
            return error("Usuário não encontrado", 404)

        return success(row)
    except Exception as e:
        return error(str(e))


# CRIAR USUÁRIO
@bp.post("/")
def criar():
    data = request.get_json()

    campos_obrigatorios = [
        "nome", "email", "telefone", "cpf",
        "data_nascimento", "senha_hash", "tipo_usuario"
    ]

    for campo in campos_obrigatorios:
        if campo not in data:
            return error(f"Campo obrigatório ausente: {campo}")

    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                INSERT INTO usuarios
                (nome, email, telefone, cpf, data_nascimento,
                 senha_hash, tipo_usuario, avatar_url)
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
                RETURNING id
            """, (
                data["nome"],
                data["email"],
                data["telefone"],
                data["cpf"],
                data["data_nascimento"],
                data["senha_hash"],
                data["tipo_usuario"],
                data.get("avatar_url")
            ))
            new_id = cur.fetchone()["id"]

        return success({"id": new_id}, "Usuário criado", 201)

    except Exception as e:
        return error(str(e))



# ATIVAR / DESATIVAR USUÁRIO
@bp.patch("/<int:id>/ativo")
def alterar_status(id):
    data = request.get_json()

    if "ativo" not in data:
        return error("Campo 'ativo' é obrigatório")

    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                UPDATE usuarios
                SET ativo = %s
                WHERE id = %s
            """, (data["ativo"], id))

        return success(message="Status atualizado")

    except Exception as e:
        return error(str(e))
