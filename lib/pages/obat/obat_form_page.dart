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
  final _kandunganController = TextEditingController();

  // Dropdown selections
  String? _selectedBentuk;
  String? _selectedSatuan;
  String? _selectedKategori;

  // Opsi dropdown
  final List<String> _bentukList = ['Tablet', 'Kapsul', 'Sirup', 'Salep', 'Injeksi'];
  final List<String> _satuanList = ['Strip', 'Botol', 'Box', 'Tube', 'Ampul'];
  final List<String> _kategoriList = ['Generik', 'Paten', 'Herbal'];

  @override
  void initState() {
    super.initState();
    if (widget.obat != null) {
      _namaController.text = widget.obat!.namaObat;
      _kandunganController.text = widget.obat!.kandungan ?? '';
      _selectedBentuk = widget.obat!.bentuk;
      _selectedSatuan = widget.obat!.satuan ?? _satuanList.first;
      _selectedKategori = widget.obat!.kategori ?? _kategoriList.first;
    }
  }

  void _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final obat = Obat(
      idObat: widget.obat?.idObat,
      namaObat: _namaController.text,
      bentuk: _selectedBentuk ?? '',
      kandungan: _kandunganController.text,
      satuan: _selectedSatuan ?? '',
      kategori: _selectedKategori ?? '',
    );

    try {
      bool sukses;
      if (widget.obat == null) {
        sukses = await ApiService.tambahObat(obat);
      } else {
        sukses = await ApiService.updateObat(obat);
      }

      if (!mounted) return;

      if (sukses) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menyimpan data")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
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
              // NAMA OBAT
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: "Nama Obat"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),

              // BENTUK DROPDOWN
              DropdownButtonFormField<String>(
                value: _selectedBentuk,
                decoration: const InputDecoration(labelText: "Bentuk Obat"),
                items: _bentukList
                    .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedBentuk = val),
                validator: (v) => v == null || v.isEmpty ? "Pilih bentuk obat" : null,
              ),

              // KANDUNGAN
              TextFormField(
                controller: _kandunganController,
                decoration: const InputDecoration(labelText: "Kandungan / Komposisi"),
              ),

              // SATUAN DROPDOWN
              DropdownButtonFormField<String>(
                value: _selectedSatuan,
                decoration: const InputDecoration(labelText: "Satuan"),
                items: _satuanList
                    .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedSatuan = val),
                validator: (v) => v == null || v.isEmpty ? "Pilih satuan" : null,
              ),

              // KATEGORI DROPDOWN
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                decoration: const InputDecoration(labelText: "Kategori"),
                items: _kategoriList
                    .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedKategori = val),
                validator: (v) => v == null || v.isEmpty ? "Pilih kategori" : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(
                  isEdit ? "Update Data" : "Simpan Data",
                  style: const TextStyle(color: Colors.white),
                ),
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
