import 'package:cuidadex_frontend/pages/chat_cuidador_page.dart';
import 'package:flutter/material.dart';

class PerfilCuidadorPage extends StatelessWidget {
  const PerfilCuidadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF7B66F0);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ===================== BODY RESPONSIVO =====================
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool telaLarga = constraints.maxWidth > 800;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: telaLarga ? 720 : double.infinity,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ================= FOTO =================
                      const SizedBox(height: 12),
                      const CircleAvatar(
                        radius: 52,
                        backgroundImage: NetworkImage(
                          "https://i.imgur.com/gJ1pT9z.png",
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ================= NOME =================
                      const Text(
                        "Jeniffer Tanaka",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // ================= DESCRIÇÃO CURTA =================
                      const Text(
                        "Profissional experiente em cuidados com criança, idosos e pessoas com deficiência",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6A6A74),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ================= PERFIL VERIFICADO =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 6),
                          Text(
                            "Perfil verificado",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // ================= TEXTO LONGO =================
                      const Text(
                        "Com mais de 10 anos de experiência, sou uma cuidadora atenciosa "
                        "e confiável. Possuo certificação e tenho antecedentes criminais limpos. "
                        "Sou apaixonada por oferecer o melhor atendimento possível aos meus clientes.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF3A3A3A),
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ================= TAGS =================
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 8,
                        children: const [
                          _Tag(label: "Criança"),
                          _Tag(label: "Idoso"),
                          _Tag(label: "PCD"),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ================= BOTÃO CONTRATAR =================
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Contratar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ================= AÇÕES =================
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite_border),
                              label: const Text("Favoritar"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryColor,
                                side: const BorderSide(color: primaryColor),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ChatCuidadorPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.chat_bubble_outline),
                              label: const Text("Iniciar Chat"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryColor,
                                side: const BorderSide(color: primaryColor),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ================= COMENTÁRIOS =================
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Comentários",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const _Comentario(
                        nome: "João Carlos",
                        texto:
                            "Jeniffer foi incrível com meu pai. Ela foi paciente, gentil e muito profissional.",
                      ),
                      const _Comentario(
                        nome: "Sarah Souza",
                        texto:
                            "Meus filhos adoram a Jenni. Ela é muito criativa e sempre inventa atividades.",
                      ),

                      const SizedBox(height: 16),

                      // ================= CAMPO COMENTÁRIO =================
                      TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Escreva seu comentário...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Enviar comentário",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ===================================================================
//                          WIDGETS AUXILIARES
// ===================================================================

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: const Color(0xFFEDE9FF),
      labelStyle: const TextStyle(
        color: Color(0xFF7B66F0),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _Comentario extends StatelessWidget {
  final String nome;
  final String texto;

  const _Comentario({
    required this.nome,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            child: Text(nome[0]),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  texto,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5E5E6A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
