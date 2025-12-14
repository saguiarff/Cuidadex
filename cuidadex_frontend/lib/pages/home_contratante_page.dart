import 'package:flutter/material.dart';
import 'perfil_cuidador_page.dart';

class HomeContratantePage extends StatefulWidget {
  const HomeContratantePage({super.key});

  @override
  State<HomeContratantePage> createState() => _HomeContratantePageState();
}

class _HomeContratantePageState extends State<HomeContratantePage> {
  // Filtros selecionados
  String especialidade = "Crianças";
  String disponibilidade = "Imediata";

  // Dados mockados de cuidadores
  final List<Map<String, dynamic>> cuidadores = [
    {
      "nome": "Ana Silva",
      "descricao": "Especialista em cuidados infantis",
      "nota": 4.9,
      "avaliacoes": 120,
      "imagem": "https://i.imgur.com/0y8Ftya.png",
    },
    {
      "nome": "Carlos Pereira",
      "descricao": "Cuidador de idosos experiente",
      "nota": 4.8,
      "avaliacoes": 95,
      "imagem": "https://i.imgur.com/6lKpQeh.png",
    },
    {
      "nome": "Jeniffer Tanaka",
      "descricao": "Apoio a todos os tipos de pessoas",
      "nota": 5.0,
      "avaliacoes": 88,
      "imagem": "https://i.imgur.com/gJ1pT9z.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F0F5),

      // ===================== APPBAR (SEM VOLTAR) =====================
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F0F5),
        elevation: 0,
        automaticallyImplyLeading: false, // 🔑 remove seta
        title: const Text(
          "Encontre um Cuidador",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1B20),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            splashRadius: 20,
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.black87),
          )
        ],
      ),

      // ===================== CORPO RESPONSIVO =====================
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool telaLarga = constraints.maxWidth > 800;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: telaLarga ? 820 : double.infinity,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= BUSCA =================
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          hintText: "Digite seu endereço ou CEP",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ================= ESPECIALIDADE =================
                      const Text(
                        "Especialidade",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1B20),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _buildFiltroEspecialidade("Crianças"),
                          _buildFiltroEspecialidade("Idosos"),
                          _buildFiltroEspecialidade("PCDs"),
                        ],
                      ),

                      const SizedBox(height: 26),

                      // ================= DISPONIBILIDADE =================
                      const Text(
                        "Disponibilidade",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1B20),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _buildFiltroDisponibilidade("Imediata"),
                          _buildFiltroDisponibilidade("Agendada"),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ================= LISTA DE CUIDADORES =================
                      ...cuidadores.map(_buildCuidadorCard).toList(),
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

  // ==========================================================
  //  CHIP DE ESPECIALIDADE
  // ==========================================================
  Widget _buildFiltroEspecialidade(String label) {
    final bool selecionado = especialidade == label;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selecionado ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: selecionado,
      onSelected: (_) => setState(() => especialidade = label),
      selectedColor: const Color(0xFF7B66F0),
      backgroundColor: Colors.white,
    );
  }

  // ==========================================================
  //  CHIP DE DISPONIBILIDADE
  // ==========================================================
  Widget _buildFiltroDisponibilidade(String label) {
    final bool selecionado = disponibilidade == label;

    return ChoiceChip(
      label: Text(
        label == "Imediata"
            ? "Disponibilidade Imediata"
            : "Agendada",
        style: TextStyle(
          color: selecionado ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: selecionado,
      onSelected: (_) => setState(() => disponibilidade = label),
      selectedColor: const Color(0xFF7B66F0),
      backgroundColor: Colors.white,
    );
  }

  // ==========================================================
  //  CARD DO CUIDADOR
  // ==========================================================
  Widget _buildCuidadorCard(Map<String, dynamic> c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              c["imagem"],
              width: 65,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c["nome"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1B20),
                  ),
                ),
                Text(
                  c["descricao"],
                  style: const TextStyle(
                    color: Color(0xFF6A6A74),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "${c["nota"]} (${c["avaliacoes"]} avaliações)",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6A6A74),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PerfilCuidadorPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B66F0),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Ver Perfil",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
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
