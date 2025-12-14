import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/usuario_model.dart';

class AuthService {
  static Future<UsuarioModel> login(
      String email, String senha) async {

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "senha": senha,
      }),
    );

    final body = jsonDecode(response.body);

    if (!body["success"]) {
      throw Exception(body["error"]);
    }

    return UsuarioModel.fromJson(body["data"]);
  }
}
