import 'package:flutter/material.dart';
import '../../models/pemasok.dart';
import '../../services/api_services.dart';
import 'pemasok_form_page.dart';

class PemasokListPage extends StatefulWidget {
  const PemasokListPage({super.key});

  @override
  State<PemasokListPage> createState() => _PemasokListPageState();
}

class _PemasokListPageState extends State<PemasokListPage> {
  List<Pemasok> pemasokList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPemasok();
  }

  Future<void> _loadPemasok() async {
    try {
      final data = await ApiService.getPemasokList();
      setState(() {
        pemasokList = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Gagal memuat pemasok: $e");
      setState(() => isLoading = false);
    }
  }

  void _hapusPemasok(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Apakah kamu yakin ingin menghapus pemasok ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.hapusPemasok(id);
      _loadPemasok();
    }
  }

  void _bukaForm({Pemasok? pemasok}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PemasokFormPage(pemasok: pemasok)),
    );

    if (result == true) {
      _loadPemasok();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Pemasok")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pemasokList.isEmpty
              ? const Center(child: Text("Belum ada data pemasok"))
              : ListView.builder(
                  itemCount: pemasokList.length,
                  itemBuilder: (context, i) {
                    final item = pemasokList[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: ListTile(
                        title: Text(item.namaPemasok),
                        subtitle: Text("${item.alamat}\n${item.kontak}"),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _bukaForm(pemasok: item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _hapusPemasok(item.idPemasok ?? 0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
