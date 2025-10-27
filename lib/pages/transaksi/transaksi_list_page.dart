import 'package:flutter/material.dart';
import '../../models/transaksi.dart';
import '../../services/api_services.dart';
import 'transaksi_form_page.dart';
import 'detail_transaksi_page.dart';

class TransaksiListPage extends StatefulWidget {
  const TransaksiListPage({super.key});

  @override
  State<TransaksiListPage> createState() => _TransaksiListPageState();
}

class _TransaksiListPageState extends State<TransaksiListPage> {
  late Future<List<Transaksi>> _transaksiList;

  @override
  void initState() {
    super.initState();
    _transaksiList = ApiService.getTransaksiList();
  }

  void _refreshData() {
    setState(() {
      _transaksiList = ApiService.getTransaksiList();
    });
  }

  void _hapusTransaksi(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: const Text('Yakin ingin menghapus transaksi ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm != true) return;

    bool success = await ApiService.hapusTransaksi(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil dihapus')),
      );
      _refreshData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus transaksi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Transaksi'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Transaksi>>(
        future: _transaksiList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada transaksi'));
          }

          final transaksiList = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _refreshData(),
            child: ListView.builder(
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                final trx = transaksiList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      'Transaksi #${trx.idTransaksi} - ${trx.jenisTransaksi.toUpperCase()}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Tanggal: ${trx.tanggal ?? '-'}\nStaff ID: ${trx.idStaff}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.receipt_long),
                          color: Colors.blueAccent,
                          tooltip: 'Detail',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailTransaksiPage(
                                idTransaksi: trx.idTransaksi!,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.orange,
                          tooltip: 'Edit',
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TransaksiFormPage(transaksi: trx),
                              ),
                            );
                            _refreshData();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          tooltip: 'Hapus',
                          onPressed: () => _hapusTransaksi(trx.idTransaksi!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Tambah'),
        icon: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransaksiFormPage()),
          );
          _refreshData();
        },
      ),
    );
  }
}
