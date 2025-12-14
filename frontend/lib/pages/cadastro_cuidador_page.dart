import 'package:flutter/material.dart';
import '../widgets/form_container.dart';


class CadastroCuidadorPage extends StatefulWidget {
  const CadastroCuidadorPage({super.key});

  @override
  State<CadastroCuidadorPage> createState() => _CadastroCuidadorPageState();
}

class _CadastroCuidadorPageState extends State<CadastroCuidadorPage> {
  bool cuidadoCriancas = false;
  bool cuidadoIdosos = false;
  bool cuidadoPcD = false;

  bool mostrarSenha = false;
  bool mostrarConfirmarSenha = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool telaGrande = constraints.maxWidth > 600;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F6F8),

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Cadastro de Cuidador",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            centerTitle: true,
          ),

          body: SingleChildScrollView(
            child: FormContainer(
              title: "Crie sua Conta de Cuidador",
              subtitle:
                  "Preencha os campos abaixo para começar a oferecer seus serviços na plataforma.",
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===========================
                    //       INFORMAÇÕES DE ACESSO
                    // ===========================
                    const Text(
                      "Informações de Acesso",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    _campoTexto("Nome completo", "Digite seu nome completo"),
                    _campoTexto("E-mail", "seuemail@exemplo.com",
                        tipo: TextInputType.emailAddress),

                    _campoSenha(
                      label: "Senha",
                      hint: "Crie uma senha forte",
                      mostrar: mostrarSenha,
                      onToggle: () =>
                          setState(() => mostrarSenha = !mostrarSenha),
                    ),

                    _campoSenha(
                      label: "Confirmar senha",
                      hint: "Repita a senha",
                      mostrar: mostrarConfirmarSenha,
                      onToggle: () => setState(
                          () => mostrarConfirmarSenha = !mostrarConfirmarSenha),
                    ),

                    const SizedBox(height: 32),

                    // ===========================
                    //       DADOS PESSOAIS
                    // ===========================
                    const Text(
                      "Dados Pessoais",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _campoTexto("Nascimento", "DD/MM/AAAA"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _campoTexto("CPF", "000.000.000-00",
                              tipo: TextInputType.number),
                        )
                      ],
                    ),

                    _campoTexto("RG", "00.000.000-0"),
                    _campoTexto("Endereço completo",
                        "Rua, Número, Bairro, Cidade - Estado"),

                    const SizedBox(height: 32),

                    // ===========================
                    //       TIPOS DE CUIDADO
                    // ===========================
                    const Text(
                      "Qual tipo de cuidado você oferece?",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    _checkbox("Crianças", cuidadoCriancas,
                        (v) => setState(() => cuidadoCriancas = v)),
                    _checkbox("Idosos", cuidadoIdosos,
                        (v) => setState(() => cuidadoIdosos = v)),
                    _checkbox("Pessoas com Deficiência (PCDs)", cuidadoPcD,
                        (v) => setState(() => cuidadoPcD = v)),

                    const SizedBox(height: 32),

                    // ===========================
                    //       DOCUMENTAÇÃO
                    // ===========================
                    const Text(
                      "Documentação",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    _uploadBox(
                      icon: Icons.upload_file,
                      title: "Certificado ou Experiência",
                      subtitle: "Anexe seu certificado ou descreva sua experiência",
                      buttonText: "Anexar certificado",
                    ),

                    _uploadBox(
                      icon: Icons.verified_user_outlined,
                      title: "Antecedentes criminais",
                      subtitle: "Anexe a certidão negativa",
                      buttonText: "Anexar documento",
                    ),

                    const SizedBox(height: 40),

                    // ===========================
                    //       BOTÃO ENVIAR
                    // ===========================
                    SizedBox(
                      width: double.infinity,
                      height: telaGrande ? 56 : 50,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cadastro enviado com sucesso!"),
                              backgroundColor: Color(0xFF6C63FF),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Concluir Cadastro",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  //                COMPONENTES REUTILIZÁVEIS
  // ============================================================

  Widget _campoTexto(String label, String hint,
      {TextInputType tipo = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            keyboardType: tipo,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              hintStyle: const TextStyle(color: Color(0xFF6A588D)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFCFC1D8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoSenha({
    required String label,
    required String hint,
    required bool mostrar,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            obscureText: !mostrar,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(
                  mostrar ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onToggle,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFCFC1D8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkbox(String label, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: value ? const Color(0xFF6C63FF) : const Color(0xFFCFC1D8),
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: (v) => onChanged(v ?? false),
        activeColor: const Color(0xFF6C63FF),
        title: Text(label),
      ),
    );
  }

  Widget _uploadBox({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFCFC1D8),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: const Color(0xFF6C63FF)),
          const SizedBox(height: 8),
          Text(
            title,
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13, color: Color(0xFF6A588D), height: 1.3),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: () {
              // Aqui você poderá integrar upload real
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF).withOpacity(0.12),
              foregroundColor: const Color(0xFF6C63FF),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
