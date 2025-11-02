import 'package:flutter/material.dart';
import '../../models/pemasok.dart';
import '../../services/api_services.dart';
import '../../utils/pdf_helper.dart'; // ✅ Tambahkan import PDF Helper
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
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.hapusPemasok(id);
      _loadPemasok();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pemasok berhasil dihapus")),
      );
    }
  }

  void _bukaForm({Pemasok? pemasok}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PemasokFormPage(pemasok: pemasok)),
    );
    if (result == true) _loadPemasok();
  }

  // ✅ Fungsi Cetak PDF
  Future<void> _cetakPDF() async {
    try {
      final data = await ApiService.getPemasokList();
      if (data.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tidak ada data untuk dicetak.")),
        );
        return;
      }

      await PDFHelper.printTable(
        title: "Laporan Data Pemasok",
        headers: ["Nama Pemasok", "Alamat", "Kontak"],
        data: data
            .map((p) => [
                  p.namaPemasok,
                  p.alamat ?? '',
                  p.kontak ?? '',
                ])
            .toList(),
      );

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal mencetak: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pemasok"),
        backgroundColor: const Color(0xFF5F8D4E),
        centerTitle: true,

        // ✅ Tombol Print di kanan atas
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.white),
            tooltip: "Cetak Data Pemasok",
            onPressed: _cetakPDF,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pemasokList.isEmpty
              ? const Center(child: Text("Belum ada data pemasok"))
              : RefreshIndicator(
                  onRefresh: _loadPemasok,
                  child: ListView.builder(
                    itemCount: pemasokList.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, i) {
                      final item = pemasokList[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          title: Text(
                            item.namaPemasok,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Alamat: ${item.alamat}",
                                  style: const TextStyle(fontSize: 13)),
                              Text("Kontak: ${item.kontak}",
                                  style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') _bukaForm(pemasok: item);
                              if (value == 'hapus') {
                                if (item.idPemasok != null) {
                                  _hapusPemasok(item.idPemasok!);
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                  value: 'edit', child: Text('Edit')),
                              const PopupMenuItem(
                                  value: 'hapus', child: Text('Hapus')),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE84C3D),
        onPressed: () => _bukaForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
