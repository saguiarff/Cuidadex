import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class UsuariosService {
  static Future<void> criarContratante({
    required String nome,
    required String email,
    required String telefone,
    required String cpf,
    required String dataNascimento,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/usuarios"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": nome,
        "email": email,
        "telefone": telefone,
        "cpf": cpf,
        "data_nascimento": dataNascimento, // yyyy-mm-dd 
        "senha_hash": senha, //depois trocar por hask real
        "tipo_usuario": "C",
      }),
    );

    final body = jsonDecode(response.body);

    if (!body["success"]) {
      throw Exception(body["error"]);
    }
  }
}
