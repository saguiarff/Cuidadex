class CuidadorModel {
  final int id;
  final String nome;
  final String? avatarUrl;
  final String? bio;
  final double valorHora;
  final double notaMedia;
  final int totalAvaliacoes;
  final bool verificado;
  final bool disponivel;

  CuidadorModel({
    required this.id,
    required this.nome,
    this.avatarUrl,
    this.bio,
    required this.valorHora,
    required this.notaMedia,
    required this.totalAvaliacoes,
    required this.verificado,
    required this.disponivel,
  });

  factory CuidadorModel.fromJson(Map<String, dynamic> json) {
    return CuidadorModel(
      id: json['id'],
      nome: json['nome'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      valorHora: double.parse(json['valor_hora'].toString()),
      notaMedia: double.parse(json['nota_media'].toString()),
      totalAvaliacoes: json['total_avaliacoes'],
      verificado: json['verificado'],
      disponivel: json['disponivel'],
    );
  }
}
