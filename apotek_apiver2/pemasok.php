<?php
include 'db.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        if (isset($_GET['id_pemasok'])) {
            $id = intval($_GET['id_pemasok']);
            $query = "SELECT * FROM pemasok WHERE id_pemasok = $id";
            $result = mysqli_query($conn, $query);
            $data = mysqli_fetch_assoc($result);
            echo json_encode($data);
        } else {
            $query = "SELECT * FROM pemasok ORDER BY id_pemasok DESC";
            $result = mysqli_query($conn, $query);
            $data = [];
            while ($row = mysqli_fetch_assoc($result)) {
                $data[] = $row;
            }
            echo json_encode($data);
        }
        break;

    case 'POST':
        $nama = $_POST['nama_pemasok'];
        $alamat = $_POST['alamat'];
        $kontak = $_POST['kontak'];

        $query = "INSERT INTO pemasok (nama_pemasok, alamat, kontak)
                  VALUES ('$nama', '$alamat', '$kontak')";
        $result = mysqli_query($conn, $query);
        echo json_encode(['success' => $result]);
        break;

    case 'PUT':
        parse_str(file_get_contents("php://input"), $_PUT);
        $id = $_GET['id'] ?? null;
        if (!$id) {
            echo json_encode(['success' => false, 'message' => 'ID tidak ditemukan']);
            exit;
        }

        $nama = $_PUT['nama_pemasok'];
        $alamat = $_PUT['alamat'];
        $kontak = $_PUT['kontak'];

        $query = "UPDATE pemasok SET 
                    nama_pemasok = '$nama',
                    alamat = '$alamat',
                    kontak = '$kontak'
                  WHERE id_pemasok = '$id'";
        $result = mysqli_query($conn, $query);
        echo json_encode(['success' => $result]);
        break;

    case 'DELETE':
        $id = $_GET['id'] ?? null;
        if (!$id) {
            echo json_encode(['success' => false, 'message' => 'ID tidak ditemukan']);
            exit;
        }

        $query = "DELETE FROM pemasok WHERE id_pemasok = '$id'";
        $result = mysqli_query($conn, $query);
        echo json_encode(['success' => $result]);
        break;

    default:
        echo json_encode(['success' => false, 'message' => 'Method tidak didukung']);
        break;
}
?>
