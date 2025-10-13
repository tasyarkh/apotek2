import 'package:flutter/material.dart';
import '../../models/transaksi.dart';
import '../../services/api_services.dart';

class TransaksiFormPage extends StatefulWidget {
  final Transaksi? transaksi;

  const TransaksiFormPage({super.key, this.transaksi});

  @override
  State<TransaksiFormPage> createState() => _TransaksiFormPageState();
}

class _TransaksiFormPageState extends State<TransaksiFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tanggalController;
  late TextEditingController _jenisController;
  late TextEditingController _namaPelangganController;
  late TextEditingController _kontakPelangganController;
  late TextEditingController _idStaffController;
  late TextEditingController _idPemasokController;

  @override
  void initState() {
    super.initState();
    _tanggalController =
        TextEditingController(text: widget.transaksi?.tanggal ?? '');
    _jenisController =
        TextEditingController(text: widget.transaksi?.jenisTransaksi ?? '');
    _namaPelangganController =
        TextEditingController(text: widget.transaksi?.namaPelanggan ?? '');
    _kontakPelangganController =
        TextEditingController(text: widget.transaksi?.kontakPelanggan ?? '');
    _idStaffController =
        TextEditingController(text: widget.transaksi?.idStaff.toString() ?? '');
    _idPemasokController = TextEditingController(
        text: widget.transaksi?.idPemasok?.toString() ?? '');
  }

  void _simpan() async {
    if (_formKey.currentState!.validate()) {
      final trx = Transaksi(
        idTransaksi: widget.transaksi?.idTransaksi,
        tanggal: _tanggalController.text,
        jenisTransaksi: _jenisController.text,
        namaPelanggan: _namaPelangganController.text,
        kontakPelanggan: _kontakPelangganController.text,
        idStaff: int.parse(_idStaffController.text),
        idPemasok: _idPemasokController.text.isNotEmpty
            ? int.tryParse(_idPemasokController.text)
            : null,
      );

      bool success;
      if (widget.transaksi == null) {
        success = await ApiService.tambahTransaksi(trx);
      } else {
        success = await ApiService.updateTransaksi(trx);
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data transaksi disimpan')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.transaksi != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Transaksi' : 'Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tanggalController,
                decoration: const InputDecoration(labelText: 'Tanggal (YYYY-MM-DD)'),
                validator: (v) => v!.isEmpty ? 'Harap isi tanggal' : null,
              ),
              TextFormField(
                controller: _jenisController,
                decoration: const InputDecoration(labelText: 'Jenis Transaksi'),
                validator: (v) => v!.isEmpty ? 'Harap isi jenis transaksi' : null,
              ),
              TextFormField(
                controller: _namaPelangganController,
                decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
              ),
              TextFormField(
                controller: _kontakPelangganController,
                decoration: const InputDecoration(labelText: 'Kontak Pelanggan'),
              ),
              TextFormField(
                controller: _idStaffController,
                decoration: const InputDecoration(labelText: 'ID Staff'),
                validator: (v) => v!.isEmpty ? 'Harap isi ID staff' : null,
              ),
              TextFormField(
                controller: _idPemasokController,
                decoration: const InputDecoration(labelText: 'ID Pemasok (opsional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpan,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
