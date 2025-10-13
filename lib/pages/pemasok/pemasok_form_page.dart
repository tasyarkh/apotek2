import 'package:flutter/material.dart';
import '../../models/pemasok.dart';

class PemasokFormPage extends StatefulWidget {
  const PemasokFormPage({super.key});

  @override
  State<PemasokFormPage> createState() => _PemasokFormPageState();
}

class _PemasokFormPageState extends State<PemasokFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kontakController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F8D4E),
        title: const Text(
          "Tambah Pemasok",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Pemasok'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _kontakController,
                decoration: const InputDecoration(labelText: 'Kontak (Telepon/Email)'),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE84C3D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newPemasok = Pemasok(
                      id: DateTime.now().millisecondsSinceEpoch,
                      namaPemasok: _namaController.text,
                      alamat: _alamatController.text,
                      kontak: _kontakController.text,
                    );
                    Navigator.pop(context, newPemasok);
                  }
                },
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Simpan Data",
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
