import 'package:flutter/material.dart';

class CadastroContratantePage extends StatefulWidget {
  const CadastroContratantePage({super.key});

  @override
  State<CadastroContratantePage> createState() => _CadastroContratantePageState();
}

class _CadastroContratantePageState extends State<CadastroContratantePage> {
  bool aceitaTermos = false;

  @override
  Widget build(BuildContext context) {
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
          "Cadastro de Contratante",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Crie sua Conta de Contratante",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF131019),
                  ),
                ),

                const SizedBox(height: 24),

                // 🟣 Seção — Informações de Acesso
                const Text(
                  "Informações de Acesso",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _buildInput("Nome Completo", "Digite seu nome completo"),
                _buildInput("E-mail", "seuemail@exemplo.com", type: TextInputType.emailAddress),
                _buildPasswordInput("Senha", "Crie uma senha forte"),
                _buildInput("Confirmar Senha", "Repita sua senha", obscure: true),

                const SizedBox(height: 32),

                // 🟣 Seção — Dados Pessoais
                const Text(
                  "Dados Pessoais",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: _buildInput("Nascimento", "DD/MM/AAAA")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInput("CPF", "000.000.000-00")),
                  ],
                ),

                _buildInput("Telefone", "(00) 00000-0000", type: TextInputType.phone),
                _buildInput("Endereço Completo", "Rua, Número, Bairro, Cidade - Estado"),

                const SizedBox(height: 32),

                // 🟣 Aceite dos Termos
                _buildCheckbox(
                  "Aceito os Termos de Uso e a Política de Privacidade",
                  aceitaTermos,
                  (val) => setState(() => aceitaTermos = val),
                ),

                const SizedBox(height: 32),

                // 🟣 Botão Final
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: aceitaTermos
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Cadastro enviado com sucesso!"),
                                backgroundColor: Color(0xFF6C63FF),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      disabledBackgroundColor: const Color(0xFFB9B4D9),
                      padding: const EdgeInsets.symmetric(vertical: 18),
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

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // 🔧 COMPONENTES REUTILIZÁVEIS
  // =====================================================

  Widget _buildInput(String label, String hint,
      {TextInputType type = TextInputType.text, bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            keyboardType: type,
            obscureText: obscure,
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
                borderSide: const BorderSide(
                  color: Color(0xFF6C63FF),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInput(String label, String hint) {
    bool obscure = true;
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                obscureText: obscure,
                decoration: InputDecoration(
                  hintText: hint,
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFCFC1D8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF6C63FF),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: value ? const Color(0xFF6C63FF) : const Color(0xFFCFC1D8),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: (val) => onChanged(val ?? false),
        activeColor: const Color(0xFF6C63FF),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
