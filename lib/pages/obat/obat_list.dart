import 'package:flutter/material.dart';
import '../../models/obat.dart';
import '../../services/api_services.dart';
import 'obat_form_page.dart';

class ObatListPage extends StatefulWidget {
  const ObatListPage({super.key});

  @override
  State<ObatListPage> createState() => _ObatListPageState();
}

class _ObatListPageState extends State<ObatListPage> {
  late Future<List<Obat>> _obatList;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _obatList = ApiService.getObatList();
  }

  void _hapusObat(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Obat"),
        content: const Text("Yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm) {
      await ApiService.hapusObat(id);
      setState(() => _loadData());
    }
  }

  void _goToForm({Obat? obat}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ObatFormPage(obat: obat)),
    );
    if (result == true) setState(() => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Obat"),
        backgroundColor: const Color(0xFF5F8D4E),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Obat>>(
        future: _obatList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data obat."));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final o = data[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  title: Text(o.namaObat),
                  subtitle: Text(
                    "Bentuk: ${o.bentuk}\nKategori: ${o.kategori}",
                    style: const TextStyle(fontSize: 13),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') _goToForm(obat: o);
                      if (value == 'hapus') _hapusObat(o.idObat!);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE84C3D),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _goToForm(),
      ),
    );
  }
}
