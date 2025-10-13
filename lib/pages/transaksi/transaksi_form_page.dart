import 'package:flutter/material.dart';
import '../../models/transaksi.dart';

class TransaksiFormPage extends StatefulWidget {
  const TransaksiFormPage({super.key});

  @override
  State<TransaksiFormPage> createState() => _TransaksiFormPageState();
}

class _TransaksiFormPageState extends State<TransaksiFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _jenisTransaksi;
  final _namaPelangganController = TextEditingController();
  final _kontakPelangganController = TextEditingController();
  final _idStaffController = TextEditingController();
  final _idPemasokController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F8D4E),
        title: const Text(
          "Tambah Transaksi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Jenis Transaksi'),
                items: const [
                  DropdownMenuItem(value: 'PEMBELIAN', child: Text('PEMBELIAN')),
                  DropdownMenuItem(value: 'PENJUALAN', child: Text('PENJUALAN')),
                  DropdownMenuItem(value: 'RETUR', child: Text('RETUR')),
                ],
                onChanged: (v) => _jenisTransaksi = v,
                validator: (v) => v == null ? 'Pilih jenis transaksi' : null,
              ),
              if (_jenisTransaksi == 'PENJUALAN') ...[
                TextFormField(
                  controller: _namaPelangganController,
                  decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
                ),
                TextFormField(
                  controller: _kontakPelangganController,
                  decoration: const InputDecoration(labelText: 'Kontak Pelanggan'),
                ),
              ],
              if (_jenisTransaksi == 'PEMBELIAN') ...[
                TextFormField(
                  controller: _idPemasokController,
                  decoration: const InputDecoration(labelText: 'ID Pemasok'),
                  keyboardType: TextInputType.number,
                ),
              ],
              TextFormField(
                controller: _idStaffController,
                decoration: const InputDecoration(labelText: 'ID Staff'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE84C3D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final transaksi = Transaksi(
                      id: DateTime.now().millisecondsSinceEpoch,
                      tanggal: DateTime.now(),
                      jenisTransaksi: _jenisTransaksi!,
                      namaPelanggan: _namaPelangganController.text.isNotEmpty
                          ? _namaPelangganController.text
                          : null,
                      kontakPelanggan: _kontakPelangganController.text.isNotEmpty
                          ? _kontakPelangganController.text
                          : null,
                      idStaff: int.parse(_idStaffController.text),
                      idPemasok: _idPemasokController.text.isNotEmpty
                          ? int.parse(_idPemasokController.text)
                          : null,
                    );
                    Navigator.pop(context, transaksi);
                  }
                },
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Simpan Transaksi",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                
              ),
              
            ],
            
          ),
          
        ),
        
      ),
    );
  }
}
