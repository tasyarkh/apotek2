import 'package:flutter/material.dart';
import '../../models/batch_obat.dart';
import '../../services/api_services.dart';
import 'batch_form_page.dart';

class BatchListPage extends StatefulWidget {
  const BatchListPage({super.key});

  @override
  State<BatchListPage> createState() => _BatchListPageState();
}

class _BatchListPageState extends State<BatchListPage> {
  late Future<List<Batch>> _batchList;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _batchList = ApiService.getBatchList();
  }

  void _hapusBatch(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Batch"),
        content: const Text("Yakin ingin menghapus data batch ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm) {
      await ApiService.hapusBatch(id);
      setState(() => _loadData());
    }
  }

  void _goToForm({Batch? batch}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BatchFormPage(batch: batch)),
    );
    if (result == true) setState(() => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Batch Obat"),
        backgroundColor: const Color(0xFF5F8D4E),
      ),
      body: FutureBuilder<List<Batch>>(
        future: _batchList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data batch."));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final b = data[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("${b.noBatch} - ${b.namaObat ?? 'Tanpa Nama Obat'}"),
                  subtitle: Text("Stok: ${b.stokTersedia} | Exp: ${b.tglKedaluwarsa}"),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') _goToForm(batch: b);
                      if (value == 'hapus') _hapusBatch(b.idBatch!);
                    },
                    itemBuilder: (_) => [
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
        onPressed: () => _goToForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
