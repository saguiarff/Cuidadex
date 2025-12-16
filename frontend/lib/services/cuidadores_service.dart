import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/cuidador_model.dart';

class CuidadoresService {
  //listar
  static Future<List<CuidadorModel>> listar({bool? verificado}) async {
    final uri = Uri.parse(
      "${ApiConfig.baseUrl}/cuidadores"
      "${verificado != null ? '?verificado=$verificado' : ''}",
    );

    final response = await http.get(
      uri,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao buscar cuidadores (${response.statusCode})");
    }

    final body = jsonDecode(response.body);

    if (body["success"] != true) {
      throw Exception(body["error"] ?? "Erro desconhecido");
    }

    final List lista = body["data"];
    return lista.map((json) => CuidadorModel.fromJson(json)).toList();
  }

  // ccriar cuidador
  static Future<void> criar({
    required int usuarioId,
    required String bio,
    required double valorHora,
    required int raioKm,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/cuidadores"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": usuarioId,
        "bio": bio,
        "valor_hora": valorHora,
        "raio_km": raioKm,
      }),
    );

    final body = jsonDecode(response.body);

    if (body["success"] != true) {
      throw Exception(body["error"] ?? "Erro ao criar cuidador");
    }
  }

  // vincular tipo (criança, idoso, PCD)
  static Future<void> vincularTipo(int usuarioId, int tipoId) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/cuidadores/tipos"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": usuarioId,
        "tipo_id": tipoId,
      }),
    );

    final body = jsonDecode(response.body);

    if (body["success"] != true) {
      throw Exception(body["error"] ?? "Erro ao vincular tipo");
    }
  }
}
