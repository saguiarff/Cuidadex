class UserModel {
  final String nome;
  final String email;
  final String senha;
  final String tipo; // "contratante" ou "cuidador"

  const UserModel({
    required this.nome,
    required this.email,
    required this.senha,
    required this.tipo,
  });
}
