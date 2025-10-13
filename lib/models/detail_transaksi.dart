class DetailTransaksi {
  int? idDetail;
  int idTransaksi;
  int idBatch;
  int jumlah;
  double subtotal;

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

  Map<String, String> toJson() {
    return {
      'id_detail': idDetail?.toString() ?? '',
      'id_transaksi': idTransaksi.toString(),
      'id_batch': idBatch.toString(),
      'jumlah': jumlah.toString(),
      'subtotal': subtotal.toString(),
    };
  }
}
