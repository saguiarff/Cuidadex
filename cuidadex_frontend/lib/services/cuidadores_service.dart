import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/cuidador_model.dart';

class CuidadoresService {
  static Future<List<CuidadorModel>> listar() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/cuidadores"),
    );

    final body = jsonDecode(response.body);

    if (!body["success"]) {
      throw Exception(body["error"]);
    }

    return (body["data"] as List)
        .map((c) => CuidadorModel.fromJson(c))
        .toList();
  }
}
