import 'package:flutter/material.dart';
import '../data/dua_data.dart'; // Import your data file

class DuaListPage extends StatelessWidget {
  final String categoryTitle;
  const DuaListPage({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    final duas = DuaRepository.data[categoryTitle] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: duas.length,
        itemBuilder: (context, index) {
          final dua = duas[index];
          return Card(
            child: ExpansionTile(
              title: Text(dua.title),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(dua.arabic, style: const TextStyle(fontSize: 22, fontFamily: 'Arial')),
                      const SizedBox(height: 10),
                      Text(dua.translation),
                      const SizedBox(height: 10),
                      Text("Ref: ${dua.reference}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}