from flask import Blueprint, request
from database import get_conn
from utils.responses import success, error
from werkzeug.security import check_password_hash

bp = Blueprint("auth", __name__, url_prefix="/api/auth")


@bp.post("/login")
def login():
    data = request.get_json()

    if not data or "email" not in data or "senha" not in data:
        return error("Email e senha são obrigatórios")

    # USUÁRIO  FALSO (TESTE)
    if data["email"] == "teste@cuidadex.com" and data["senha"] == "1234":
        return success(
            {
                "id": 0,
                "nome": "Usuário Teste",
                "email": "teste@cuidadex.com",
                "tipo_usuario": "C"
            },
            "Login realizado (usuário de teste)"
        )

    # LOGIN REAL (BANCO DE DADOS)
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                SELECT id, nome, email, senha_hash, tipo_usuario, ativo
                FROM usuarios
                WHERE email = %s
            """, (data["email"],))
            user = cur.fetchone()

        if not user:
            return error("Credenciais inválidas", 401)

        if not user["ativo"]:
            return error("Usuário desativado", 403)

        if not check_password_hash(user["senha_hash"], data["senha"]):
            return error("Credenciais inválidas", 401)

        return success(
            {
                "id": user["id"],
                "nome": user["nome"],
                "email": user["email"],
                "tipo_usuario": user["tipo_usuario"]
            },
            "Login realizado"
        )

    except Exception as e:
        return error(str(e))
