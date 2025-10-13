class DetailTransaksi {
  final int id;
  final int idTransaksi;
  final int idBatch;
  final int jumlah;
  final double subtotal;

  DetailTransaksi({
    required this.id,
    required this.idTransaksi,
    required this.idBatch,
    required this.jumlah,
    required this.subtotal,
  });
}
