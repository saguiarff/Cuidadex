import 'package:flutter/material.dart';
import 'cadastro_cuidador_page.dart';

class RequisitosCuidadorPage extends StatelessWidget {
  const RequisitosCuidadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requisitos = [
      {
        "icone": Icons.cake_outlined,
        "titulo": "Idade mínima",
        "descricao": "É necessário ter 18 anos ou mais.",
      },
      {
        "icone": Icons.badge_outlined,
        "titulo": "Documentação",
        "descricao": "Documento de identidade válido e comprovante de residência.",
      },
      {
        "icone": Icons.school_outlined,
        "titulo": "Formação e experiência",
        "descricao": "Certificados ou comprovação de experiência na área de cuidados.",
      },
      {
        "icone": Icons.verified_user_outlined,
        "titulo": "Verificação de antecedentes",
        "descricao": "Checagem de antecedentes criminais é obrigatória.",
      },
      {
        "icone": Icons.people_outline,
        "titulo": "Habilidades interpessoais",
        "descricao": "Empatia, paciência e boa comunicação são essenciais.",
      },
      {
        "icone": Icons.healing_outlined,
        "titulo": "Primeiros socorros",
        "descricao": "Certificação em primeiros socorros é um diferencial.",
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool telaGrande = constraints.maxWidth > 600;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Requisitos para Cuidador",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  margin: EdgeInsets.all(telaGrande ? 32 : 16),
                  padding: EdgeInsets.all(telaGrande ? 32 : 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Seja um Cuidador",
                        style: TextStyle(
                          fontSize: telaGrande ? 26 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        "Confira abaixo os requisitos detalhados para se juntar à nossa plataforma e começar a oferecer seus cuidados.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: telaGrande ? 16 : 14,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ================= LISTA RESPONSIVA =================
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: requisitos.map((item) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.symmetric(
                                  vertical: telaGrande ? 16 : 12,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9F8FC),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEDE9FF),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        item["icone"] as IconData,
                                        size: telaGrande ? 28 : 24,
                                        color: const Color(0xFF6C63FF),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item["titulo"] as String,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: telaGrande ? 18 : 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item["descricao"] as String,
                                            style: TextStyle(
                                              fontSize: telaGrande ? 15 : 13,
                                              color: Colors.black54,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ============ BOTÃO FINAL =============
                      SizedBox(
                        width: double.infinity,
                        height: telaGrande ? 56 : 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CadastroCuidadorPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: Text(
                            "Iniciar cadastro como cuidador",
                            style: TextStyle(
                              fontSize: telaGrande ? 17 : 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
