import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/cuidador_model.dart';

class CuidadoresService {
  static Future<List<CuidadorModel>> listar({bool? verificado}) async {
    final uri = Uri.parse(
      "${ApiConfig.baseUrl}/api/cuidadores"
      "${verificado != null ? '?verificado=$verificado' : ''}",
    );

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao buscar cuidadores (${response.statusCode})");
    }

    final body = jsonDecode(response.body);

    if (body["success"] != true) {
      throw Exception(body["error"] ?? "Erro desconhecido");
    }

    final List lista = body["data"];

    return lista
        .map((json) => CuidadorModel.fromJson(json))
        .toList();
  }
}
