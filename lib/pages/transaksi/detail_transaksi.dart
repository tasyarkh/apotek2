import 'package:flutter/material.dart';
import '../../models/detail_transaksi.dart';
import '../../services/api_services.dart';

class DetailTransaksiPage extends StatefulWidget {
  final int idTransaksi;

  const DetailTransaksiPage({super.key, required this.idTransaksi});

  @override
  State<DetailTransaksiPage> createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  late Future<List<DetailTransaksi>> _detailList;

  @override
  void initState() {
    super.initState();
    _detailList = ApiService.getDetailTransaksiList(widget.idTransaksi);
  }

  void _refresh() {
    setState(() {
      _detailList = ApiService.getDetailTransaksiList(widget.idTransaksi);
    });
  }

  void _hapus(int id) async {
    bool ok = await ApiService.hapusDetailTransaksi(id);
    if (ok) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Detail dihapus")));
      _refresh();
    }
  }

  void _tambahDetailDialog() {
    final idBatchCtrl = TextEditingController();
    final jumlahCtrl = TextEditingController();
    final subtotalCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Detail Transaksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: idBatchCtrl, decoration: const InputDecoration(labelText: 'ID Batch')),
            TextField(controller: jumlahCtrl, decoration: const InputDecoration(labelText: 'Jumlah')),
            TextField(controller: subtotalCtrl, decoration: const InputDecoration(labelText: 'Subtotal')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final detail = DetailTransaksi(
                idTransaksi: widget.idTransaksi,
                idBatch: int.parse(idBatchCtrl.text),
                jumlah: int.parse(jumlahCtrl.text),
                subtotal: double.parse(subtotalCtrl.text),
              );
              bool ok = await ApiService.tambahDetailTransaksi(detail);
              if (ok && mounted) {
                Navigator.pop(context);
                _refresh();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Transaksi #${widget.idTransaksi}')),
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
          if (details.isEmpty) return const Center(child: Text('Belum ada detail transaksi'));

          return ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              final d = details[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Batch ID: ${d.idBatch}'),
                  subtitle: Text('Jumlah: ${d.jumlah} | Subtotal: ${d.subtotal}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _hapus(d.idDetail!),
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
