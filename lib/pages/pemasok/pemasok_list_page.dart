import 'package:flutter/material.dart';
import '../../models/pemasok.dart';
import 'pemasok_form_page.dart';

class PemasokListPage extends StatefulWidget {
  const PemasokListPage({super.key});

  @override
  State<PemasokListPage> createState() => _PemasokListPageState();
}

class _PemasokListPageState extends State<PemasokListPage> {
  List<Pemasok> pemasokList = [
    Pemasok(id: 1, namaPemasok: 'PT Sehat Selalu', alamat: 'Jakarta', kontak: '08123456789'),
    Pemasok(id: 2, namaPemasok: 'CV Farma Jaya', alamat: 'Bandung', kontak: '082233445566'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F8D4E),
        title: const Text(
          "Data Pemasok",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: pemasokList.length,
        itemBuilder: (context, index) {
          final p = pemasokList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(p.namaPemasok, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${p.alamat}\nKontak: ${p.kontak}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE84C3D),
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PemasokFormPage()),
          );
          if (result != null && result is Pemasok) {
            setState(() {
              pemasokList.add(result);
            });
          }
        },
      ),
    );
  }
}
