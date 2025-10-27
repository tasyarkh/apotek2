class DetailTransaksi {
  final int? idDetail;
  final int idTransaksi; // ✅ penting
  final int idBatch;
  final int jumlah;
  final double subtotal;

  DetailTransaksi({
    this.idDetail,
    required this.idTransaksi,
    required this.idBatch,
    required this.jumlah,
    required this.subtotal,
  });

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) {
    return DetailTransaksi(
      idDetail: int.tryParse(json['id_detail'].toString()),
      idTransaksi: int.parse(json['id_transaksi'].toString()),
      idBatch: int.parse(json['id_batch'].toString()),
      jumlah: int.parse(json['jumlah'].toString()),
      subtotal: double.parse(json['subtotal'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_detail': idDetail,
      'id_transaksi': idTransaksi,
      'id_batch': idBatch,
      'jumlah': jumlah,
      'subtotal': subtotal,
    };
  }
}
