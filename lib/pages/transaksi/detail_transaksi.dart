import 'package:flutter/material.dart';
import '../../models/detail_transaksi.dart';

class DetailTransaksiPage extends StatefulWidget {
  final int idTransaksi;
  const DetailTransaksiPage({super.key, required this.idTransaksi});

  @override
  State<DetailTransaksiPage> createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  final _formKey = GlobalKey<FormState>();
  final _idBatchController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _hargaSatuanController = TextEditingController();

  List<DetailTransaksi> detailList = [];

  double get totalTransaksi =>
      detailList.fold(0, (sum, item) => sum + item.subtotal);

  void _tambahDetail() {
    if (_formKey.currentState!.validate()) {
      final idBatch = int.parse(_idBatchController.text);
      final jumlah = int.parse(_jumlahController.text);
      final harga = double.parse(_hargaSatuanController.text);
      final subtotal = jumlah * harga;

      setState(() {
        detailList.add(DetailTransaksi(
          id: DateTime.now().millisecondsSinceEpoch,
          idTransaksi: widget.idTransaksi,
          idBatch: idBatch,
          jumlah: jumlah,
          subtotal: subtotal,
        ));
        _idBatchController.clear();
        _jumlahController.clear();
        _hargaSatuanController.clear();
      });
    }
  }

  void _hapusDetail(int index) {
    setState(() {
      detailList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F8D4E),
        title: const Text(
          "Detail Transaksi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _idBatchController,
                    decoration: const InputDecoration(labelText: 'ID Batch Obat'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _jumlahController,
                    decoration: const InputDecoration(labelText: 'Jumlah Obat'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _hargaSatuanController,
                    decoration: const InputDecoration(labelText: 'Harga Satuan (Rp)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _tambahDetail,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Tambah Detail",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE84C3D),
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: detailList.isEmpty
                  ? const Center(
                      child: Text("Belum ada detail transaksi."),
                    )
                  : ListView.builder(
                      itemCount: detailList.length,
                      itemBuilder: (context, index) {
                        final d = detailList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text("Batch ID: ${d.idBatch}"),
                            subtitle: Text(
                                "Jumlah: ${d.jumlah}\nSubtotal: Rp ${d.subtotal.toStringAsFixed(0)}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _hapusDetail(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF5F8D4E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Rp ${totalTransaksi.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, detailList);
              },
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                "Selesai & Simpan",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE84C3D),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
