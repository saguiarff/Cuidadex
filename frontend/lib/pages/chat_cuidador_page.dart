import 'dart:async';
import 'package:flutter/material.dart';
import '../models/cuidador_model.dart';

class ChatCuidadorPage extends StatefulWidget {
  final CuidadorModel cuidador;

  const ChatCuidadorPage({
    super.key,
    required this.cuidador,
  });

  @override
  State<ChatCuidadorPage> createState() => _ChatCuidadorPageState();
}

class _ChatCuidadorPageState extends State<ChatCuidadorPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_Mensagem> _mensagens = [];

  @override
  void initState() {
    super.initState();

    _mensagens.add(
      _Mensagem(
        texto:
            "Olá! Estou disponível para conversar. O que gostaria de saber?",
        enviadaPeloUsuario: false,
        hora: _horaAtual(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _enviarMensagem() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      _mensagens.add(
        _Mensagem(
          texto: texto,
          enviadaPeloUsuario: true,
          hora: _horaAtual(),
        ),
      );
    });

    _controller.clear();
    _rolarParaBaixo();

    // resposta mockada (por enquanto)
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _mensagens.add(
          _Mensagem(
            texto:
                "Tenho sim 😊 Vou lhe contar um pouco sobre minha experiência.",
            enviadaPeloUsuario: false,
            hora: _horaAtual(),
          ),
        );
      });

      _rolarParaBaixo();
    });
  }

  void _rolarParaBaixo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _horaAtual() {
    final now = TimeOfDay.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7B66F0);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F9),
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                widget.cuidador.avatarUrl ??
                    "assets/images/avatar_padrao.jpg",
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cuidador.nome,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.cuidador.disponivel
                      ? "Disponível"
                      : "Indisponível",
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.cuidador.disponivel
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                return _BalaoMensagem(mensagem: _mensagens[index]);
              },
            ),
          ),

        
          SafeArea(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    color: primaryColor,
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Digite sua mensagem...",
                        filled: true,
                        fillColor: const Color(0xFFF1F0F5),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _enviarMensagem(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _enviarMensagem,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _Mensagem {
  final String texto;
  final bool enviadaPeloUsuario;
  final String hora;

  _Mensagem({
    required this.texto,
    required this.enviadaPeloUsuario,
    required this.hora,
  });
}


class _BalaoMensagem extends StatelessWidget {
  final _Mensagem mensagem;

  const _BalaoMensagem({required this.mensagem});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7B66F0);
    final isUser = mensagem.enviadaPeloUsuario;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? primaryColor.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight:
                isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              mensagem.texto,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 4),
            Text(
              mensagem.hora,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
