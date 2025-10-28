import 'package:flutter/material.dart';
import '../../models/batch_obat.dart';
import '../../models/obat.dart';
import '../../models/pemasok.dart';
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
  final _stokTambahanController = TextEditingController();
  final _stokTersediaController = TextEditingController();

  int? _selectedObatId;
  int? _selectedPemasokId;
  List<Obat> _obatList = [];
  List<Pemasok> _pemasokList = [];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadObatDanPemasok();

    if (widget.batch != null) {
      final b = widget.batch!;
      _selectedObatId = b.idObat;
      _selectedPemasokId = b.idPemasok; // ✅ kalau sedang edit
      _noBatchController.text = b.noBatch;
      _tglController.text = b.tglKedaluwarsa;
      _hargaBeliController.text = b.hargaBeli.toString();
      _hargaJualController.text = b.hargaJual.toString();
      _stokAwalController.text = b.stokAwal.toString();
      _stokTersediaController.text = b.stokTersedia.toString();
    }
  }

  @override
  void dispose() {
    _noBatchController.dispose();
    _tglController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    _stokAwalController.dispose();
    _stokTambahanController.dispose();
    _stokTersediaController.dispose();
    super.dispose();
  }

  Future<void> _loadObatDanPemasok() async {
    final obatList = await ApiService.getObatList();
    final pemasokList = await ApiService.getPemasokList();
    if (!mounted) return;
    setState(() {
      _obatList = obatList;
      _pemasokList = pemasokList;
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (picked != null && mounted) {
      setState(() {
        _tglController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _hitungStok() {
    final stokAwal = int.tryParse(_stokAwalController.text) ?? 0;
    final tambahan = int.tryParse(_stokTambahanController.text) ?? 0;
    _stokTersediaController.text = (stokAwal + tambahan).toString();
  }

  Future<void> _simpan() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate() ||
        _selectedObatId == null ||
        _selectedPemasokId == null) return;

    setState(() => _isSaving = true);

    final batch = Batch(
      idBatch: widget.batch?.idBatch,
      idObat: _selectedObatId!,
      idPemasok: _selectedPemasokId!,
      noBatch: _noBatchController.text,
      tglKedaluwarsa: _tglController.text,
      hargaBeli: double.parse(_hargaBeliController.text),
      hargaJual: double.parse(_hargaJualController.text),
      stokAwal: int.parse(_stokAwalController.text),
      stokTersedia: int.parse(_stokTersediaController.text),
    );

    try {
      final success = widget.batch == null
          ? await ApiService.tambahBatch(batch)
          : await ApiService.updateBatch(batch);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan")),
        );
        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menyimpan data")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.batch != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Batch Obat" : "Tambah Batch Obat"),
        backgroundColor: const Color(0xFF5F8D4E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // === Dropdown Obat ===
              DropdownButtonFormField<int>(
                value: _selectedObatId,
                items: _obatList
                    .map((o) => DropdownMenuItem(
                          value: o.idObat,
                          child: Text(o.namaObat),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedObatId = v),
                decoration: const InputDecoration(
                  labelText: "Pilih Obat",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null ? "Pilih obat terlebih dahulu" : null,
              ),
              const SizedBox(height: 12),

              // === Dropdown Pemasok ===
              DropdownButtonFormField<int>(
                value: _selectedPemasokId,
                items: _pemasokList
                    .map((p) => DropdownMenuItem(
                          value: p.idPemasok,
                          child: Text(p.namaPemasok),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedPemasokId = v),
                decoration: const InputDecoration(
                  labelText: "Pilih Pemasok",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null ? "Pilih pemasok terlebih dahulu" : null,
              ),
              const SizedBox(height: 12),

              // === Input Nomor Batch ===
              TextFormField(
                controller: _noBatchController,
                decoration: const InputDecoration(
                  labelText: "Nomor Batch",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Nomor batch wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // === Tanggal Kedaluwarsa ===
              TextFormField(
                controller: _tglController,
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(
                  labelText: "Tanggal Kedaluwarsa",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Tanggal kedaluwarsa wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // === Harga Beli ===
              TextFormField(
                controller: _hargaBeliController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga Beli",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Harga beli wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // === Harga Jual ===
              TextFormField(
                controller: _hargaJualController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga Jual",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Harga jual wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // === Stok Awal ===
              TextFormField(
                controller: _stokAwalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stok Sekarang",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _hitungStok(),
                validator: (v) =>
                    v!.isEmpty ? "Stok sekarang wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // === Stok Tambahan ===
              TextFormField(
                controller: _stokTambahanController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stok Tambahan",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _hitungStok(),
              ),
              const SizedBox(height: 12),

              // === Total Stok ===
              TextFormField(
                controller: _stokTersediaController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Total Stok (Otomatis)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _isSaving ? null : _simpan,
                icon: const Icon(Icons.save),
                label: Text(isEdit ? "Update" : "Simpan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isSaving ? Colors.grey : const Color(0xFFE84C3D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
