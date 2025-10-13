import '../models/batch_obat.dart';
import '../models/obat.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://10.0.2.2/apotek_api/";

  // -------------------- OBAT --------------------
  static Future<List<Obat>> getObatList() async {
    final response = await http.get(Uri.parse("${baseUrl}obat.php"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Obat.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data obat");
    }
  }

  static Future<bool> tambahObat(Obat obat) async {
    final response = await http.post(
      Uri.parse("${baseUrl}obat.php"),
      body: obat.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> updateObat(Obat obat) async {
    final response = await http.put(
      Uri.parse("${baseUrl}obat.php?id=${obat.idObat}"),
      body: obat.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> hapusObat(int id) async {
    final response = await http.delete(
      Uri.parse("${baseUrl}obat.php?id=$id"),
    );
    return response.statusCode == 200;
  }

  // -------------------- BATCH --------------------
  static Future<List<Batch>> getBatchList() async {
    final response = await http.get(Uri.parse("${baseUrl}batch.php"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Batch.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data batch");
    }
  }

  static Future<bool> tambahBatch(Batch batch) async {
    final response = await http.post(
      Uri.parse("${baseUrl}batch.php"),
      body: batch.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> updateBatch(Batch batch) async {
    final response = await http.put(
      Uri.parse("${baseUrl}batch.php?id=${batch.idBatch}"),
      body: batch.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> hapusBatch(int id) async {
    final response = await http.delete(
      Uri.parse("${baseUrl}batch.php?id=$id"),
    );
    return response.statusCode == 200;
  }
}
