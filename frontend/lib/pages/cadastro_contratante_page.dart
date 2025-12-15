import 'package:flutter/material.dart';
import '../services/usuarios_service.dart';

class CadastroContratantePage extends StatefulWidget {
  const CadastroContratantePage({super.key});

  @override
  State<CadastroContratantePage> createState() =>
      _CadastroContratantePageState();
}

class _CadastroContratantePageState extends State<CadastroContratantePage> {
  bool aceitaTermos = false;
  bool carregando = false;

  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmarSenhaCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _nascimentoCtrl = TextEditingController();
  final _enderecoCtrl = TextEditingController();

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmarSenhaCtrl.dispose();
    _cpfCtrl.dispose();
    _telefoneCtrl.dispose();
    _nascimentoCtrl.dispose();
    _enderecoCtrl.dispose();
    super.dispose();
  }


  String _somenteNumeros(String valor) {
    return valor.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String _formatarData(String data) {
    // DD/MM/AAAA → YYYY-MM-DD
    final partes = data.split('/');
    return "${partes[2]}-${partes[1]}-${partes[0]}";
  }

  Future<void> _cadastrar() async {
    if (_senhaCtrl.text != _confirmarSenhaCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem")),
      );
      return;
    }

    setState(() => carregando = true);

    try {
      await UsuariosService.criarContratante(
        nome: _nomeCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        telefone: _somenteNumeros(_telefoneCtrl.text),
        cpf: _somenteNumeros(_cpfCtrl.text),
        dataNascimento: _formatarData(_nascimentoCtrl.text),
        senha: _senhaCtrl.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cadastro realizado com sucesso!"),
          backgroundColor: Color(0xFF6C63FF),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar: $e")),
      );
    } finally {
      setState(() => carregando = false);
    }
  }

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
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
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

                const Text(
                  "Informações de Acesso",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _buildInput("Nome Completo", "Digite seu nome completo",
                    controller: _nomeCtrl),
                _buildInput("E-mail", "seuemail@exemplo.com",
                    controller: _emailCtrl,
                    type: TextInputType.emailAddress),
                _buildPasswordInput("Senha", "Crie uma senha forte",
                    controller: _senhaCtrl),
                _buildPasswordInput("Confirmar Senha", "Repita sua senha",
                    controller: _confirmarSenhaCtrl),

                const SizedBox(height: 32),

                const Text(
                  "Dados Pessoais",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        "Nascimento",
                        "DD/MM/AAAA",
                        controller: _nascimentoCtrl,
                        type: TextInputType.datetime,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInput(
                        "CPF",
                        "000.000.000-00",
                        controller: _cpfCtrl,
                        type: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                _buildInput(
                  "Telefone",
                  "(00) 00000-0000",
                  controller: _telefoneCtrl,
                  type: TextInputType.phone,
                ),

                _buildInput(
                  "Endereço Completo",
                  "Rua, Número, Bairro, Cidade - Estado",
                  controller: _enderecoCtrl,
                ),

                const SizedBox(height: 32),

                _buildCheckbox(
                  "Aceito os Termos de Uso e a Política de Privacidade",
                  aceitaTermos,
                  (val) => setState(() => aceitaTermos = val),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        aceitaTermos && !carregando ? _cadastrar : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      disabledBackgroundColor: const Color(0xFFB9B4D9),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: carregando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
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

  Widget _buildInput(
    String label,
    String hint, {
    required TextEditingController controller,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: type,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFCFC1D8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInput(
    String label,
    String hint, {
    required TextEditingController controller,
  }) {
    bool obscure = true;
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextField(
                controller: controller,
                obscureText: obscure,
                decoration: InputDecoration(
                  hintText: hint,
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => obscure = !obscure),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckbox(
      String label, bool value, Function(bool) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color:
              value ? const Color(0xFF6C63FF) : const Color(0xFFCFC1D8),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: (val) => onChanged(val ?? false),
        activeColor: const Color(0xFF6C63FF),
        title: Text(label),
      ),
    );
  }
}
