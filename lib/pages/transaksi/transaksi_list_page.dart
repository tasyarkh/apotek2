import 'package:flutter/material.dart';
import '../../models/transaksi.dart';
import '../../services/api_services.dart';
import 'transaksi_form_page.dart';
import 'detail_transaksi.dart';

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
    bool success = await ApiService.hapusTransaksi(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil dihapus')),
      );
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Transaksi'),
      ),
      body: FutureBuilder<List<Transaksi>>(
        future: _transaksiList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada transaksi'));
          }

          final transaksiList = snapshot.data!;
          return ListView.builder(
            itemCount: transaksiList.length,
            itemBuilder: (context, index) {
              final trx = transaksiList[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Transaksi #${trx.idTransaksi} - ${trx.jenisTransaksi}'),
                  subtitle: Text('Tanggal: ${trx.tanggal}\nStaff ID: ${trx.idStaff}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.list_alt),
                        color: Colors.indigo,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailTransaksiPage(idTransaksi: trx.idTransaksi!),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.orange,
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
                        onPressed: () => _hapusTransaksi(trx.idTransaksi!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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
