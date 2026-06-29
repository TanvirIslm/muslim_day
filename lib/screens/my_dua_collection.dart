import 'package:flutter/material.dart';

class MyCollectionPage extends StatelessWidget {
  const MyCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Collection")),
      body: const Center(child: Text("Your saved Duas will appear here.")),
    );
  }
}