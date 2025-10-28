import 'package:flutter/material.dart';
import '../../models/pemasok.dart';
import '../../services/api_services.dart';

class PemasokFormPage extends StatefulWidget {
  final Pemasok? pemasok;

  const PemasokFormPage({super.key, this.pemasok});

  @override
  State<PemasokFormPage> createState() => _PemasokFormPageState();
}

class _PemasokFormPageState extends State<PemasokFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kontakController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pemasok != null) {
      _namaController.text = widget.pemasok!.namaPemasok;
      _alamatController.text = widget.pemasok!.alamat ?? '';
      _kontakController.text = widget.pemasok!.kontak ?? '';

    }
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    final pemasok = Pemasok(
      idPemasok: widget.pemasok?.idPemasok,
      namaPemasok: _namaController.text,
      alamat: _alamatController.text,
      kontak: _kontakController.text,
    );

    bool success;
    if (widget.pemasok == null) {
      success = await ApiService.tambahPemasok(pemasok);
    } else {
      success = await ApiService.updatePemasok(pemasok);
    }

    if (success && mounted) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan data")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.pemasok != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Pemasok" : "Tambah Pemasok"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: "Nama Pemasok"),
                validator: (value) => value!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: "Alamat"),
                validator: (value) => value!.isEmpty ? "Alamat wajib diisi" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _kontakController,
                decoration: const InputDecoration(labelText: "Kontak (Telepon / Email)"),
                validator: (value) => value!.isEmpty ? "Kontak wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _simpanData,
                icon: const Icon(Icons.save),
                label: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
