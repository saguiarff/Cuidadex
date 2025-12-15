class UsuarioModel {
  final int id;
  final String nome;
  final String tipoUsuario; // "C" ou "G"
  final String token;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.tipoUsuario,
    required this.token,
  });

  bool get isContratante => tipoUsuario == "C";
  bool get isCuidador => tipoUsuario == "G";

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nome: json['nome'],
      tipoUsuario: json['tipo_usuario'],
      token: json['token'],
    );
  }
}
