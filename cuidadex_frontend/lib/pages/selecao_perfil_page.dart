import 'package:flutter/material.dart';
import 'requisitos_cuidador_page.dart';
import 'cadastro_contratante_page.dart';

class SelecaoPerfilPage extends StatefulWidget {
  const SelecaoPerfilPage({super.key});

  @override
  State<SelecaoPerfilPage> createState() => _SelecaoPerfilPageState();
}

class _SelecaoPerfilPageState extends State<SelecaoPerfilPage> {
  String selectedRole = "Contratante";

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),

      // ================= APP BAR DE VOLTAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Center(
        child: Container(
          width: 360,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // =============== TÍTULO ===============
              const Text(
                "Bem-vindo! Você é\ncontratante ou cuidador?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 35),

              // ================= CONTRATANTE CARD =================
              _roleCard(
                title: "Contratante",
                subtitle: "Encontre o cuidador ideal",
                icon: Icons.person_search,
                selected: selectedRole == "Contratante",
                onTap: () => setState(() => selectedRole = "Contratante"),
              ),

              const SizedBox(height: 20),

              // ================= CUIDADOR CARD =================
              _roleCard(
                title: "Cuidador",
                subtitle: "Ofereça seus serviços",
                icon: Icons.favorite_border,
                selected: selectedRole == "Cuidador",
                onTap: () => setState(() => selectedRole = "Cuidador"),
              ),

              const SizedBox(height: 40),

              // ================= BOTÃO CONTINUAR =================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedRole == "Cuidador") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RequisitosCuidadorPage()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CadastroContratantePage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Continuar",
                    style: TextStyle(
                      fontSize: 16,
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
    );
  }

  // =======================================================================
  //                   NOVO CARTÃO DE SELEÇÃO — MAIOR E BONITO
  // =======================================================================
  Widget _roleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    const primaryColor = Color(0xFF6C63FF);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0EAFE) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? primaryColor : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),

        child: Column(
          children: [
            Icon(icon, size: 40, color: primaryColor),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
