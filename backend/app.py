from flask import Flask
from flask_cors import CORS
from dotenv import load_dotenv

from config import FLASK_HOST, FLASK_PORT

from controllers.usuarios import bp as usuarios_bp
from controllers.cuidadores import bp as cuidadores_bp
from controllers.tipos_cuidado import bp as tipos_cuidado_bp
from controllers.agendamentos import bp as agendamentos_bp
from controllers.avaliacoes import bp as avaliacoes_bp
from controllers.auth import bp as auth_bp

load_dotenv()

app = Flask(__name__)
app.json.ensure_ascii = False

# cors pro flutter web
CORS(
    app,
    resources={r"/api/*": {"origins": "*"}},
    supports_credentials=True
)

@app.get("/")
def home():
    return {"status": "Cuidadex API rodando"}

# registro dos Blueprints
app.register_blueprint(usuarios_bp)
app.register_blueprint(cuidadores_bp)
app.register_blueprint(tipos_cuidado_bp)
app.register_blueprint(agendamentos_bp)
app.register_blueprint(avaliacoes_bp)
app.register_blueprint(auth_bp)

if __name__ == "__main__":
    app.run(
        host=FLASK_HOST,  
        port=FLASK_PORT,   
        debug=True
    )
