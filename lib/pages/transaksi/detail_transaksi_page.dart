import 'package:flutter/material.dart';
import '../../models/detail_transaksi.dart';
import '../../models/batch_obat.dart';
import '../../services/api_services.dart';

class DetailTransaksiPage extends StatefulWidget {
  final int idTransaksi;

  const DetailTransaksiPage({super.key, required this.idTransaksi});

  @override
  State<DetailTransaksiPage> createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  late Future<List<DetailTransaksi>> _detailList;
  late Future<List<Batch>> _batchList;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _detailList = ApiService.getDetailTransaksiList(widget.idTransaksi);
    _batchList = ApiService.getBatchList();
  }

  void _refresh() {
    setState(() {
      _loadData();
    });
  }

  Future<void> _hapusDetail(int id) async {
    final ok = await ApiService.hapusDetailTransaksi(id);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Detail transaksi berhasil dihapus")),
      );
      _refresh();
    }
  }

  void _tambahDetailDialog() async {
    final jumlahCtrl = TextEditingController();
    Batch? selectedBatch;

    // ambil daftar batch dari API
    final batches = await ApiService.getBatchList();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text("Tambah Detail Transaksi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Batch>(
                value: selectedBatch,
                decoration: const InputDecoration(
                  labelText: 'Pilih Batch Obat',
                  border: OutlineInputBorder(),
                ),
                items: batches.map((b) {
                  return DropdownMenuItem(
                    value: b,
                    child: Text("${b.namaObat ?? 'Obat'} - Batch ${b.noBatch}"),
                  );
                }).toList(),
                onChanged: (val) => setModalState(() => selectedBatch = val),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: jumlahCtrl,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              if (selectedBatch != null)
                Text(
                  "Harga satuan: Rp ${selectedBatch!.hargaJual.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedBatch == null || jumlahCtrl.text.isEmpty) return;

                final jumlah = int.tryParse(jumlahCtrl.text) ?? 0;
                final subtotal =
                    (selectedBatch!.hargaJual) * jumlah.toDouble();

                final detail = DetailTransaksi(
                  idTransaksi: widget.idTransaksi, // ✅ sekarang valid
                  idBatch: selectedBatch!.idBatch!, // ✅ pakai idBatch dari model
                  jumlah: jumlah,
                  subtotal: subtotal,
                );

                bool ok = await ApiService.tambahDetailTransaksi(detail);
                if (ok && mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Detail transaksi berhasil ditambah")),
                  );
                  _refresh();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gagal menambah detail")),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Detail Transaksi #${widget.idTransaksi}")),
      body: FutureBuilder<List<DetailTransaksi>>(
        future: _detailList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final details = snapshot.data ?? [];
          if (details.isEmpty) {
            return const Center(child: Text('Belum ada detail transaksi'));
          }

          return ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              final d = details[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Batch ID: ${d.idBatch}"),
                  subtitle: Text(
                      "Jumlah: ${d.jumlah}\nSubtotal: Rp ${d.subtotal.toStringAsFixed(2)}"),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _hapusDetail(d.idDetail!),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahDetailDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
