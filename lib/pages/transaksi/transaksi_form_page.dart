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
  final TextEditingController _tanggalCtrl = TextEditingController();
  final TextEditingController _idStaffCtrl = TextEditingController();
  String? _jenisTransaksi; // "masuk" atau "keluar"

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.transaksi != null) {
      _tanggalCtrl.text = widget.transaksi!.tanggal ?? '';
      _idStaffCtrl.text = widget.transaksi!.idStaff.toString();
      _jenisTransaksi = widget.transaksi!.jenisTransaksi;
    }
  }

  @override
  void dispose() {
    _tanggalCtrl.dispose();
    _idStaffCtrl.dispose();
    super.dispose();
  }

  Future<void> _simpanTransaksi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final transaksi = Transaksi(
      idTransaksi: widget.transaksi?.idTransaksi,
      tanggal: _tanggalCtrl.text,
      jenisTransaksi: _jenisTransaksi ?? '',
      idStaff: int.parse(_idStaffCtrl.text),
    );

    bool sukses;
    if (widget.transaksi == null) {
      sukses = await ApiService.tambahTransaksi(transaksi);
    } else {
      sukses = await ApiService.updateTransaksi(transaksi);
    }

    setState(() => _loading = false);

    if (!mounted) return;

    if (sukses) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.transaksi == null
              ? 'Transaksi berhasil ditambahkan'
              : 'Transaksi berhasil diperbarui'),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan transaksi')),
      );
    }
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_tanggalCtrl.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggalCtrl.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.transaksi != null;

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
              // 📅 tanggal transaksi
              TextFormField(
                controller: _tanggalCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Transaksi',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _pilihTanggal(context),
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Tanggal harus diisi' : null,
              ),
              const SizedBox(height: 16),

              // 🔄 jenis transaksi (masuk/keluar)
              DropdownButtonFormField<String>(
                value: _jenisTransaksi,
                decoration: const InputDecoration(
                  labelText: 'Jenis Transaksi',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'masuk',
                    child: Text('Masuk (Barang Masuk)'),
                  ),
                  DropdownMenuItem(
                    value: 'keluar',
                    child: Text('Keluar (Barang Keluar)'),
                  ),
                ],
                onChanged: (value) => setState(() => _jenisTransaksi = value),
                validator: (val) =>
                    val == null ? 'Pilih jenis transaksi' : null,
              ),
              const SizedBox(height: 16),

              // 👩‍⚕️ id staff
              TextFormField(
                controller: _idStaffCtrl,
                decoration: const InputDecoration(
                  labelText: 'ID Staff',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'ID Staff harus diisi' : null,
              ),
              const SizedBox(height: 24),

              // 💾 tombol simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: _loading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_loading ? 'Menyimpan...' : 'Simpan'),
                  onPressed: _loading ? null : _simpanTransaksi,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
