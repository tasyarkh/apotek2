import 'package:flutter/material.dart';
import '../../models/staff.dart';
import '../../models/batch_obat.dart';
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
  final _keteranganController = TextEditingController();
  final _jumlahController = TextEditingController();

  List<Staff> _staffList = [];
  List<Batch> _batchList = [];

  int? _selectedStaffId;
  int? _selectedBatchId;
  double? _hargaJual;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();

    if (widget.transaksi != null) {
      _keteranganController.text = widget.transaksi!.keterangan ?? '';
      _selectedStaffId = widget.transaksi!.idStaff;
    }
  }

  Future<void> _loadData() async {
    final staff = await ApiService.getStaffList();
    final batch = await ApiService.getBatchList();
    if (mounted) {
      setState(() {
        _staffList = staff;
        _batchList = batch;
      });
    }
  }

  Future<void> _simpanTransaksi() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    if (_selectedStaffId == null || _selectedBatchId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih staff dan obat terlebih dahulu")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 🧾 1. Tambah transaksi utama dulu
      final response = await ApiService.tambahTransaksiSimple(
        idStaff: _selectedStaffId!,
        keterangan: _keteranganController.text,
      );

      if (response == null || response['success'] != true) {
        throw Exception("Gagal membuat transaksi utama");
      }

      final idTransaksi = response['id_transaksi'];
      if (idTransaksi == null) {
        throw Exception("ID transaksi tidak diterima dari server");
      }

      // 📦 2. Tambah detail transaksi (barang keluar)
      final jumlah = int.parse(_jumlahController.text);
      final harga = _hargaJual ?? 0;
      final subtotal = jumlah * harga;

      final detailSuccess = await ApiService.tambahDetailBarangKeluar(
        idTransaksi: idTransaksi,
        idBatch: _selectedBatchId!,
        jumlah: jumlah,
        subtotal: subtotal,
      );

      if (!detailSuccess) throw Exception("Gagal menambah detail transaksi");

      // 🎉 Berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Barang keluar berhasil dicatat")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Gagal menyimpan: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.transaksi != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Transaksi" : "Transaksi Barang Keluar"),
        backgroundColor: const Color(0xFF5F8D4E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 🧍 STAFF
              DropdownButtonFormField<int>(
                value: _selectedStaffId,
                decoration: const InputDecoration(
                  labelText: "Pilih Staff",
                  border: OutlineInputBorder(),
                ),
                items: _staffList
                    .map((s) => DropdownMenuItem(
                          value: s.idStaff,
                          child: Text(s.namaStaff),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedStaffId = v),
                validator: (v) =>
                    v == null ? "Pilih staff terlebih dahulu" : null,
              ),
              const SizedBox(height: 12),

              // 💊 OBAT / BATCH
              DropdownButtonFormField<int>(
                value: _selectedBatchId,
                decoration: const InputDecoration(
                  labelText: "Pilih Batch Obat",
                  border: OutlineInputBorder(),
                ),
                items: _batchList
                    .map((b) => DropdownMenuItem(
                          value: b.idBatch,
                          child: Text("${b.namaObat ?? ''} (${b.noBatch})"),
                        ))
                    .toList(),
                onChanged: (v) {
                  final selected =
                      _batchList.firstWhere((b) => b.idBatch == v);
                  setState(() {
                    _selectedBatchId = v;
                    _hargaJual = selected.hargaJual;
                  });
                },
                validator: (v) =>
                    v == null ? "Pilih batch obat terlebih dahulu" : null,
              ),
              const SizedBox(height: 12),

              // 🔢 JUMLAH KELUAR
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Jumlah Keluar",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Masukkan jumlah keluar" : null,
              ),
              const SizedBox(height: 12),

              // 📝 KETERANGAN
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(
                  labelText: "Keterangan (opsional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // 💾 SIMPAN
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _simpanTransaksi,
                icon: const Icon(Icons.save),
                label: Text(isEdit ? "Update" : "Simpan Transaksi"),
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
