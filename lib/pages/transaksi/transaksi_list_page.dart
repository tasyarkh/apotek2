import 'package:flutter/material.dart';
import '../../models/transaksi.dart';
import 'transaksi_form_page.dart'; // nanti form tambah transaksi
import '../../services/api_services.dart';
import '../../widget/loading_indicator.dart';

class TransaksiListPage extends StatefulWidget {
  const TransaksiListPage({Key? key}) : super(key: key);

  @override
  State<TransaksiListPage> createState() => _TransaksiListPageState();
}

class _TransaksiListPageState extends State<TransaksiListPage> {
  late Future<List<Transaksi>> _transaksiList;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _transaksiList = ApiService.getTransaksiList();
  }

  Future<void> _refresh() async {
    setState(() => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaksi Barang Keluar")),
      body: FutureBuilder<List<Transaksi>>(
        future: _transaksiList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada transaksi."));
          }

          final transaksiList = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                final trx = transaksiList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long, color: Colors.blue),
                    title: Text("Transaksi #${trx.idTransaksi ?? '-'}"),
                    subtitle: Text(
                      "Tanggal: ${trx.tglTransaksi}\nStaff: ${trx.namaStaff ?? '-'}\nKeterangan: ${trx.keterangan ?? '-'}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text("Hapus Transaksi?"),
                                content: const Text(
                                  "Yakin ingin menghapus transaksi ini?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text("Hapus"),
                                  ),
                                ],
                              ),
                        );
                        if (confirm == true) {
                          final success = await ApiService.hapusTransaksi(
                            trx.idTransaksi!,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? "Berhasil dihapus"
                                    : "Gagal menghapus",
                              ),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );
                          if (success) _refresh();
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TransaksiFormPage(transaksi: trx),
                        ),
                      ).then((_) => _refresh());
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TransaksiFormPage()),
          );
          _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
