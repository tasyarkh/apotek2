import 'package:flutter/material.dart';
import '../../models/batch_obat.dart';
import '../../models/obat.dart';
import '../../services/api_services.dart';

class BatchFormPage extends StatefulWidget {
  final Batch? batch;
  const BatchFormPage({super.key, this.batch});

  @override
  State<BatchFormPage> createState() => _BatchFormPageState();
}

class _BatchFormPageState extends State<BatchFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _noBatchController = TextEditingController();
  final _tglController = TextEditingController();
  final _hargaBeliController = TextEditingController();
  final _hargaJualController = TextEditingController();
  final _stokAwalController = TextEditingController();
  final _stokTersediaController = TextEditingController();
  int? _selectedObatId;
  List<Obat> _obatList = [];

  @override
  void initState() {
    super.initState();
    _loadObat();

    if (widget.batch != null) {
      final b = widget.batch!;
      _noBatchController.text = b.noBatch;
      _tglController.text = b.tglKedaluwarsa;
      _hargaBeliController.text = b.hargaBeli.toString();
      _hargaJualController.text = b.hargaJual.toString();
      _stokAwalController.text = b.stokAwal.toString();
      _stokTersediaController.text = b.stokTersedia.toString();
      _selectedObatId = b.idObat;
    }
  }

  void _loadObat() async {
    final list = await ApiService.getObatList();
    setState(() => _obatList = list);
  }

  void _simpan() async {
    if (_formKey.currentState!.validate() && _selectedObatId != null) {
      final batch = Batch(
        idBatch: widget.batch?.idBatch,
        idObat: _selectedObatId!,
        noBatch: _noBatchController.text,
        tglKedaluwarsa: _tglController.text,
        hargaBeli: double.parse(_hargaBeliController.text),
        hargaJual: double.parse(_hargaJualController.text),
        stokAwal: int.parse(_stokAwalController.text),
        stokTersedia: int.parse(_stokTersediaController.text),
      );

      bool success;
      if (widget.batch == null) {
        success = await ApiService.tambahBatch(batch);
      } else {
        success = await ApiService.updateBatch(batch);
      }

      if (success && mounted) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Gagal menyimpan data")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.batch != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Batch" : "Tambah Batch"),
        backgroundColor: const Color(0xFF5F8D4E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                value: _selectedObatId,
                items: _obatList
                    .map((o) => DropdownMenuItem<int>(
                          value: o.idObat,
                          child: Text(o.namaObat),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedObatId = v),
                decoration: const InputDecoration(labelText: "Pilih Obat"),
                validator: (v) => v == null ? "Pilih obat terlebih dahulu" : null,
              ),
              TextFormField(
                controller: _noBatchController,
                decoration: const InputDecoration(labelText: "Nomor Batch"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _tglController,
                decoration: const InputDecoration(labelText: "Tanggal Kedaluwarsa (YYYY-MM-DD)"),
              ),
              TextFormField(
                controller: _hargaBeliController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga Beli"),
              ),
              TextFormField(
                controller: _hargaJualController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga Jual"),
              ),
              TextFormField(
                controller: _stokAwalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Stok Awal"),
              ),
              TextFormField(
                controller: _stokTersediaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Stok Tersedia"),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save),
                label: const Text("Simpan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE84C3D),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
