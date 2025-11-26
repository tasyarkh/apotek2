<?php
include 'db.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
  http_response_code(200);
  exit;
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {

  // 🔹 GET: ambil detail transaksi tertentu
  case 'GET':
    if (isset($_GET['id_transaksi'])) {
      $id = $_GET['id_transaksi'];
      $query = "SELECT d.*, o.nama_obat
                FROM detail_transaksi d
                JOIN obat o ON d.id_obat = o.id_obat
                WHERE d.id_transaksi = '$id'";
      $result = mysqli_query($conn, $query);
      $data = [];
      while ($row = mysqli_fetch_assoc($result)) $data[] = $row;
      echo json_encode($data);
    } else {
      echo json_encode(['success' => false, 'message' => 'ID transaksi tidak diberikan']);
    }
    break;

  // 🔹 POST: tambah detail transaksi
  case 'POST':
    $input = json_decode(file_get_contents("php://input"), true);
    $id_transaksi = $input['id_transaksi'] ?? null;
    $id_obat = $input['id_obat'] ?? null;
    $jumlah = isset($input['jumlah']) ? intval($input['jumlah']) : 0;
    $subtotal = isset($input['subtotal']) ? floatval($input['subtotal']) : 0;

    if (!$id_transaksi || !$id_obat || $jumlah <= 0) {
        echo json_encode(['success' => false, 'message' => 'Data tidak lengkap atau jumlah <= 0']);
        exit;
    }

    // ⛔ Tidak perlu lagi update stok manual karena sudah ditangani trigger MySQL

    $query = "INSERT INTO detail_transaksi (id_transaksi, id_obat, jumlah, subtotal)
              VALUES ('$id_transaksi', '$id_obat', $jumlah, $subtotal)";
    $result = mysqli_query($conn, $query);

    if ($result) {
        echo json_encode(['success' => true, 'message' => 'Barang keluar berhasil dicatat']);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Gagal mencatat detail transaksi',
            'query' => $query,
            'error' => mysqli_error($conn)
        ]);
    }

    break;

  default:
    echo json_encode(['success' => false, 'message' => 'Method tidak dikenali']);
}
?>
