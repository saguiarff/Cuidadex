import 'package:flutter/material.dart';
import '../widgets/form_container.dart';
import '../services/usuarios_service.dart';
import '../services/cuidadores_service.dart';

class CadastroCuidadorPage extends StatefulWidget {
  const CadastroCuidadorPage({super.key});

  @override
  State<CadastroCuidadorPage> createState() => _CadastroCuidadorPageState();
}

class _CadastroCuidadorPageState extends State<CadastroCuidadorPage> {
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmarSenhaCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _nascimentoCtrl = TextEditingController();
  final _enderecoCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  bool cuidadoCriancas = false;
  bool cuidadoIdosos = false;
  bool cuidadoPcD = false;

  bool mostrarSenha = false;
  bool mostrarConfirmarSenha = false;
  bool carregando = false;

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
    _bioCtrl.dispose();
    super.dispose();
  }

  String _soNumeros(String v) => v.replaceAll(RegExp(r'[^0-9]'), '');

  String _formatarData(String data) {
    final p = data.split('/');
    return "${p[2]}-${p[1]}-${p[0]}";
  }

  Future<void> _cadastrarCuidador() async {
    if (_senhaCtrl.text != _confirmarSenhaCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem")),
      );
      return;
    }

    if (!cuidadoCriancas && !cuidadoIdosos && !cuidadoPcD) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione ao menos um tipo de cuidado")),
      );
      return;
    }

    setState(() => carregando = true);

    try {
      
      final usuarioId = await UsuariosService.criarCuidador(
        nome: _nomeCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        telefone: _soNumeros(_telefoneCtrl.text),
        cpf: _soNumeros(_cpfCtrl.text),
        dataNascimento: _formatarData(_nascimentoCtrl.text),
        senha: _senhaCtrl.text,
      );

      
      await CuidadoresService.criar(
        usuarioId: usuarioId,
        bio: _bioCtrl.text.isEmpty
            ? "Cuidador profissional"
            : _bioCtrl.text,
        valorHora: 30.0,
        raioKm: 10,
      );

      if (cuidadoCriancas) {
        await CuidadoresService.vincularTipo(usuarioId, 1);
      }
      if (cuidadoIdosos) {
        await CuidadoresService.vincularTipo(usuarioId, 2);
      }
      if (cuidadoPcD) {
        await CuidadoresService.vincularTipo(usuarioId, 3);
      }

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
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Cadastro de Cuidador",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: FormContainer(
          title: "Crie sua Conta de Cuidador",
          subtitle:
              "Preencha os campos abaixo para começar a oferecer seus serviços.",
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _campoTexto("Nome completo", controller: _nomeCtrl),
                _campoTexto("E-mail",
                    controller: _emailCtrl,
                    tipo: TextInputType.emailAddress),

                _campoSenha(
                  "Senha",
                  mostrarSenha,
                  _senhaCtrl,
                  () => setState(() => mostrarSenha = !mostrarSenha),
                ),

                _campoSenha(
                  "Confirmar senha",
                  mostrarConfirmarSenha,
                  _confirmarSenhaCtrl,
                  () => setState(
                      () => mostrarConfirmarSenha = !mostrarConfirmarSenha),
                ),

                Row(
                  children: [
                    Expanded(
                        child: _campoTexto("Nascimento",
                            controller: _nascimentoCtrl)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _campoTexto("CPF",
                            controller: _cpfCtrl,
                            tipo: TextInputType.number)),
                  ],
                ),

                _campoTexto("Telefone",
                    controller: _telefoneCtrl,
                    tipo: TextInputType.phone),

                _campoTexto("Endereço", controller: _enderecoCtrl),

                _campoTexto("Sobre você",
                    controller: _bioCtrl, maxLines: 3),

                const SizedBox(height: 20),

                _checkbox("Crianças", cuidadoCriancas,
                    (v) => setState(() => cuidadoCriancas = v)),
                _checkbox("Idosos", cuidadoIdosos,
                    (v) => setState(() => cuidadoIdosos = v)),
                _checkbox("PCD", cuidadoPcD,
                    (v) => setState(() => cuidadoPcD = v)),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: carregando ? null : _cadastrarCuidador,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
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
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(String label,
      {required TextEditingController controller,
      TextInputType tipo = TextInputType.text,
      int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: tipo,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _campoSenha(String label, bool mostrar,
      TextEditingController controller, VoidCallback toggle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: !mostrar,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            icon:
                Icon(mostrar ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _checkbox(String label, bool value, Function(bool) onChanged) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(label),
      activeColor: const Color(0xFF6C63FF),
    );
  }
}
