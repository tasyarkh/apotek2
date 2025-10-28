class Transaksi {
  final int? idTransaksi;
  final int idStaff;
  final String tglTransaksi;
  final String keterangan;
  final String? namaStaff;

  Transaksi({
    this.idTransaksi,
    required this.idStaff,
    required this.tglTransaksi,
    required this.keterangan,
    this.namaStaff,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      idTransaksi: int.tryParse(json['id_transaksi'].toString()),
      idStaff: int.parse(json['id_staff'].toString()),
      tglTransaksi: json['tgl_transaksi'] ?? '',
      keterangan: json['keterangan'] ?? '',
      namaStaff: json['nama_staff'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_transaksi': idTransaksi?.toString() ?? '',
      'id_staff': idStaff.toString(),
      'tgl_transaksi': tglTransaksi,
      'keterangan': keterangan,
      'nama_staff': namaStaff ?? '',
    };
  }
}
