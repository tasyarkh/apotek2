<?php
include 'db.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
  http_response_code(200);
  exit;
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {

  // 🔹 GET: ambil semua transaksi
  case 'GET':
    $query = "SELECT t.*, s.nama_staff 
              FROM transaksi t
              JOIN staff s ON t.id_staff = s.id_staff
              ORDER BY t.id_transaksi DESC";
    $result = mysqli_query($conn, $query);
    $data = [];
    while ($row = mysqli_fetch_assoc($result)) {
      $data[] = $row;
    }
    echo json_encode($data);
    break;

  // 🔹 POST: tambah transaksi baru
  case 'POST':
    $input = json_decode(file_get_contents("php://input"), true);

    $tgl_transaksi = $input['tgl_transaksi'] ?? date('Y-m-d');
    $id_staff = $input['id_staff'] ?? null;
    $keterangan = $input['keterangan'] ?? '';

    if (!$id_staff) {
      echo json_encode(['success' => false, 'message' => 'ID Staff wajib diisi']);
      exit;
    }

    $query = "INSERT INTO transaksi (tgl_transaksi, id_staff, keterangan)
              VALUES ('$tgl_transaksi', '$id_staff', '$keterangan')";
    $result = mysqli_query($conn, $query);
    $id_transaksi = mysqli_insert_id($conn);

    echo json_encode([
      'success' => $result,
      'message' => $result ? '✅ Transaksi berhasil ditambahkan' : '❌ Gagal menambah transaksi',
      'id_transaksi' => $id_transaksi,
      'error' => $result ? null : mysqli_error($conn)
    ]);
    break;

  // 🔹 DELETE
  case 'DELETE':
    $id = $_GET['id'] ?? null;
    if (!$id) {
      echo json_encode(['success' => false, 'message' => 'ID transaksi tidak ditemukan']);
      exit;
    }

    $query = "DELETE FROM transaksi WHERE id_transaksi = '$id'";
    $result = mysqli_query($conn, $query);

    echo json_encode([
      'success' => $result,
      'message' => $result ? '✅ Transaksi berhasil dihapus' : '❌ Gagal menghapus transaksi',
      'error' => $result ? null : mysqli_error($conn)
    ]);
    break;

  default:
    echo json_encode(['success' => false, 'message' => 'Method tidak dikenali']);
}
?>
