import 'package:flutter/material.dart';
import '../../models/obat.dart';
import '../../services/api_services.dart';

class ObatFormPage extends StatefulWidget {
  final Obat? obat;
  const ObatFormPage({super.key, this.obat});

  @override
  State<ObatFormPage> createState() => _ObatFormPageState();
}

class _ObatFormPageState extends State<ObatFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _bentukController = TextEditingController();
  final _kandunganController = TextEditingController();
  final _satuanController = TextEditingController();
  final _kategoriController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.obat != null) {
      _namaController.text = widget.obat!.namaObat;
      _bentukController.text = widget.obat!.bentuk;
      _kandunganController.text = widget.obat!.kandungan;
      _satuanController.text = widget.obat!.satuan;
      _kategoriController.text = widget.obat!.kategori;
    }
  }

  void _simpan() async {
    if (_formKey.currentState!.validate()) {
      final obat = Obat(
        idObat: widget.obat?.idObat,
        namaObat: _namaController.text,
        bentuk: _bentukController.text,
        kandungan: _kandunganController.text,
        satuan: _satuanController.text,
        kategori: _kategoriController.text,
      );

      bool sukses;
      if (widget.obat == null) {
        sukses = await ApiService.tambahObat(obat);
      } else {
        sukses = await ApiService.updateObat(obat);
      }

      if (sukses && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menyimpan data")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.obat != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F8D4E),
        title: Text(isEdit ? "Edit Obat" : "Tambah Obat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: "Nama Obat"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _bentukController,
                decoration: const InputDecoration(labelText: "Bentuk (tablet, kapsul...)"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _kandunganController,
                decoration: const InputDecoration(labelText: "Kandungan / Komposisi"),
              ),
              TextFormField(
                controller: _satuanController,
                decoration: const InputDecoration(labelText: "Satuan (strip, botol, box)"),
              ),
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(labelText: "Kategori (generik, paten, herbal)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(isEdit ? "Update Data" : "Simpan Data",
                    style: const TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE84C3D),
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
