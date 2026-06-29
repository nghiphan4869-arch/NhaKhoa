import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nhakhoa/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CapNhatThongTin extends StatefulWidget {
  final Map<String, dynamic>? patientData;
  const CapNhatThongTin({super.key, this.patientData});

  @override
  State<CapNhatThongTin> createState() => _CapNhatThongTinState();
}

class _CapNhatThongTinState extends State<CapNhatThongTin> {
  late final TextEditingController hoTenController;
  late final TextEditingController sdtController;
  late final TextEditingController emailController;
  late final TextEditingController diaChiController;
  late final TextEditingController ngaySinhController;
  String gioiTinh = "Nam";
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller với dữ liệu hiện tại (nếu có)
    hoTenController = TextEditingController(text: widget.patientData?['HoTen'] ?? '');
    sdtController = TextEditingController(text: widget.patientData?['SDT'] ?? '');
    emailController = TextEditingController(text: widget.patientData?['Email'] ?? '');
    diaChiController = TextEditingController(text: widget.patientData?['DiaChi'] ?? '');

    String rawNgaySinh = widget.patientData?['NgaySinh'] ?? '';
    if (rawNgaySinh.contains('T')) {
      rawNgaySinh = rawNgaySinh.split('T')[0];
    }
    ngaySinhController = TextEditingController(text: rawNgaySinh);

    final String rawGioiTinh = widget.patientData?['GioiTinh'] ?? 'Nam';
    if (rawGioiTinh == "Nam" || rawGioiTinh == "Nữ") {
      gioiTinh = rawGioiTinh;
    } else {
      gioiTinh = "Nam";
    }
  }

  @override
  void dispose() {
    hoTenController.dispose();
    sdtController.dispose();
    emailController.dispose();
    diaChiController.dispose();
    ngaySinhController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final String hoTen = hoTenController.text.trim();
    final String sdt = sdtController.text.trim();
    final String email = emailController.text.trim();
    final String diaChi = diaChiController.text.trim();
    final String ngaySinh = ngaySinhController.text.trim();

    if (hoTen.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền họ tên")),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final maBenhNhan = prefs.getInt('maBenhNhan') ?? 0;

      if (maBenhNhan == 0) {
        throw Exception("Không tìm thấy mã bệnh nhân");
      }

      final response = await http.put(
        Uri.parse('${ApiConfig.benhNhanUrl}/$maBenhNhan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'HoTen': hoTen,
          'Email': email.isEmpty ? null : email,
          'SDT': sdt,
          'NgaySinh': ngaySinh.isEmpty ? null : ngaySinh,
          'GioiTinh': gioiTinh,
          'DiaChi': diaChi.isEmpty ? null : diaChi,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cập nhật thông tin thành công")),
          );
          Navigator.pop(context, true); // Trả về true để reload trang trước
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Không thể cập nhật hồ sơ');
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text('Lỗi cập nhật'),
            content: Text(e.toString().replaceAll('Exception: ', '')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f8fc),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Cập nhật thông tin",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Avatar
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(
                    Icons.person,
                    size: 65,
                    color: Color(0xff4b5fb5),
                  ),
                ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Color(0xff4b5fb5),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),

            /// Form nhập liệu
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  _textField(
                    "Họ tên",
                    Icons.person_outline,
                    hoTenController,
                  ),
                  const SizedBox(height: 15),
                  _textField(
                    "Số điện thoại",
                    Icons.phone,
                    sdtController,
                  ),
                  const SizedBox(height: 15),
                  _textField(
                    "Email",
                    Icons.email_outlined,
                    emailController,
                  ),
                  const SizedBox(height: 15),
                  _textField(
                    "Địa chỉ",
                    Icons.location_on_outlined,
                    diaChiController,
                  ),
                  const SizedBox(height: 15),
                  _textField(
                    "Ngày sinh (YYYY-MM-DD)",
                    Icons.calendar_today,
                    ngaySinhController,
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: gioiTinh,
                    decoration: InputDecoration(
                      labelText: "Giới tính",
                      prefixIcon: const Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Nam",
                        child: Text("Nam"),
                      ),
                      DropdownMenuItem(
                        value: "Nữ",
                        child: Text("Nữ"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        gioiTinh = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            /// NÚT LƯU THAY ĐỔI
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4b5fb5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _isSaving ? null : _saveChanges,
                icon: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                      ),
                label: Text(
                  _isSaving ? "Đang lưu..." : "Lưu thay đổi",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textField(
    String label,
    IconData icon,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}