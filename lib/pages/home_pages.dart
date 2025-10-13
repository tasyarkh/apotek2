import 'package:flutter/material.dart';
import 'obat/obat_list.dart';
import 'pemasok/pemasok_list_page.dart';
import 'staff/staff_list_page.dart';
import 'batch/batch_list_page.dart';
import 'transaksi/transaksi_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // abu lembut
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F8D4E),
        title: const Text(
          'Apotek Rakyat Mandiri',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuCard(
              context,
              icon: Icons.medication,
              title: 'Data Obat',
              color: const Color(0xFF5F8D4E),
              page: const ObatListPage(),
            ),
            _buildMenuCard(
              context,
              icon: Icons.local_shipping,
              title: 'Pemasok',
              color: const Color(0xFFE84C3D),
              page: const PemasokListPage(),
            ),
            _buildMenuCard(
              context,
              icon: Icons.people,
              title: 'Staff',
              color: const Color(0xFF5F8D4E),
              page: const StaffListPage(),
            ),
            _buildMenuCard(
              context,
              icon: Icons.inventory_2,
              title: 'Batch Obat',
              color: const Color(0xFFE84C3D),
              page: const BatchListPage(),
            ),
            _buildMenuCard(
              context,
              icon: Icons.receipt_long,
              title: 'Transaksi',
              color: const Color(0xFF5F8D4E),
              page: const TransaksiListPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required IconData icon,
      required String title,
      required Color color,
      required Widget page}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 30,
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            )
          ],
        ),
      ),
    );
  }
}
