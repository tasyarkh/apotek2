import 'package:flutter/material.dart';
import '../../models/staff.dart';
import '../../services/api_services.dart';

class StaffFormPage extends StatefulWidget {
  final Staff? staff;

  const StaffFormPage({super.key, this.staff});

  @override
  State<StaffFormPage> createState() => _StaffFormPageState();
}

class _StaffFormPageState extends State<StaffFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSaving = false; // untuk mencegah double tap dan ticker error

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      _namaController.text = widget.staff!.namaStaff;
      _usernameController.text = widget.staff!.username;
      _passwordController.text = widget.staff!.password;
    }
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final staff = Staff(
      idStaff: widget.staff?.idStaff,
      namaStaff: _namaController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    bool success = false;
    try {
      if (widget.staff == null) {
        success = await ApiService.tambahStaff(staff);
      } else {
        success = await ApiService.updateStaff(staff);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }

    if (!mounted) return; // mencegah akses context setelah dispose

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan data")),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.staff != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Staff" : "Tambah Staff"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: "Nama Staff"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Username wajib diisi" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Password wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _simpanData,
                icon: const Icon(Icons.save),
                label: Text(_isSaving ? "Menyimpan..." : "Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
