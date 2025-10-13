import 'package:flutter/material.dart';
import '../../models/transaksi.dart';
import 'transaksi_form_page.dart';

class TransaksiListPage extends StatefulWidget {
  const TransaksiListPage({super.key});

  @override
  State<TransaksiListPage> createState() => _TransaksiListPageState();
}

class _TransaksiListPageState extends State<TransaksiListPage> {
  List<Transaksi> transaksiList = [
    Transaksi(
      id: 1,
      tanggal: DateTime(2025, 10, 1, 9, 30),
      jenisTransaksi: 'PEMBELIAN',
      namaPelanggan: null,
      kontakPelanggan: null,
      idStaff: 1,
      idPemasok: 2,
    ),
    Transaksi(
      id: 2,
      tanggal: DateTime(2025, 10, 3, 14, 10),
      jenisTransaksi: 'PENJUALAN',
      namaPelanggan: 'Siti Rahma',
      kontakPelanggan: '08123456789',
      idStaff: 2,
      idPemasok: null,
    ),
  ];

  String formatTanggal(DateTime date) {
    return "${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F8D4E),
        title: const Text(
          "Daftar Transaksi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: transaksiList.length,
        itemBuilder: (context, index) {
          final t = transaksiList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                t.jenisTransaksi,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Tanggal: ${formatTanggal(t.tanggal)}\n"
                "Staff ID: ${t.idStaff} ${t.namaPelanggan != null ? '\nPelanggan: ${t.namaPelanggan}' : ''}",
              ),
              trailing: Icon(
                t.jenisTransaksi == 'PENJUALAN'
                    ? Icons.shopping_cart
                    : t.jenisTransaksi == 'PEMBELIAN'
                    ? Icons.local_shipping
                    : Icons.undo,
                color: Colors.grey[700],
              ),
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
            MaterialPageRoute(builder: (_) => const TransaksiFormPage()),
          );
          if (result != null && result is Transaksi) {
            setState(() {
              transaksiList.add(result);
            });
          }
        },
      ),
    );
  }
}
