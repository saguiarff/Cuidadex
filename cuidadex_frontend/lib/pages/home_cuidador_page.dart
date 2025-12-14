import 'package:flutter/material.dart';

class HomeCuidadorPage extends StatelessWidget {
  const HomeCuidadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Área do Cuidador"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Bem-vindo(a), Cuidador!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
