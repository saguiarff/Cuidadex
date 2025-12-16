import 'package:flutter/material.dart';
import '../services/cuidadores_service.dart';
import '../models/cuidador_model.dart';
import 'perfil_cuidador_page.dart';

class HomeContratantePage extends StatefulWidget {
  const HomeContratantePage({super.key});

  @override
  State<HomeContratantePage> createState() => _HomeContratantePageState();
}

class _HomeContratantePageState extends State<HomeContratantePage> {
  String especialidade = "Crianças";
  String disponibilidade = "Imediata";

  late Future<List<CuidadorModel>> _futureCuidadores;

  @override
  void initState() {
    super.initState();
    _futureCuidadores = CuidadoresService.listar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F0F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F0F5),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Encontre um Cuidador",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1B20),
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<List<CuidadorModel>>(
        future: _futureCuidadores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro ao carregar cuidadores",
                style: TextStyle(color: Colors.red.shade600),
              ),
            );
          }

          final cuidadores = snapshot.data ?? [];

          if (cuidadores.isEmpty) {
            return const Center(
              child: Text("Nenhum cuidador disponível no momento"),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final bool telaLarga = constraints.maxWidth > 800;

              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: telaLarga ? 820 : double.infinity,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
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

                          const SizedBox(height: 26),

                          ...cuidadores
                              .map((c) => _buildCuidadorCard(c))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCuidadorCard(CuidadorModel c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              c.avatarUrl ?? "assets/images/avatar_padrao.jpg",
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
                  c.nome,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Text(
                  c.bio?.isNotEmpty == true
                      ? c.bio!
                      : "Cuidador profissional",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6A6A74),
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "${c.notaMedia.toStringAsFixed(1)} (${c.totalAvaliacoes} avaliações)",
                      style: const TextStyle(fontSize: 13),
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
                          builder: (_) =>
                              PerfilCuidadorPage(cuidador: c),
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
                        fontSize: 13,
                        color: Colors.white,
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
