import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nhakhoa/Screen/CaNhan.dart';
import 'package:nhakhoa/Screen/CapNhatThongTin.dart';
import 'package:nhakhoa/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HoSoBenhNhan extends StatefulWidget {
  const HoSoBenhNhan({super.key});

  @override
  State<HoSoBenhNhan> createState() => _HoSoBenhNhanState();
}

class _HoSoBenhNhanState extends State<HoSoBenhNhan> {
  Map<String, dynamic>? _patientData;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
  }

  Future<void> _fetchPatientData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final maBenhNhan = prefs.getInt('maBenhNhan') ?? 0;

      if (maBenhNhan == 0) {
        setState(() {
          _error = 'Không tìm thấy mã bệnh nhân';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.benhNhanUrl}/$maBenhNhan'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _patientData = data;
          _isLoading = false;
        });

        // Đồng bộ dữ liệu mới nhất vào SharedPreferences
        await prefs.setString('hoTen', data['HoTen'] ?? 'Khách');
        await prefs.setString('email', data['Email'] ?? 'Chưa cập nhật');
        await prefs.setString('sdt', data['SDT'] ?? 'Chưa cập nhật');
        await prefs.setString('ngaySinh', data['NgaySinh'] ?? 'Chưa cập nhật');
        await prefs.setString('gioiTinh', data['GioiTinh'] ?? 'Chưa cập nhật');
        await prefs.setString('diaChi', data['DiaChi'] ?? 'Chưa cập nhật');
        await prefs.setString('hinhAnh', data['HinhAnh'] ?? '');
      } else {
        setState(() {
          _error = 'Không thể tải hồ sơ (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Lỗi kết nối máy chủ';
        _isLoading = false;
      });
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr == 'Chưa cập nhật') {
      return 'Chưa cập nhật';
    }
    try {
      final cleanDate = dateStr.split('T')[0];
      final parts = cleanDate.split('-');
      if (parts.length == 3) {
        return "${parts[2]}/${parts[1]}/${parts[0]}";
      }
      return cleanDate;
    } catch (_) {
      return dateStr;
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CaNhan()),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Hồ sơ bệnh nhân",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xff4b5fb5),
              ),
            )
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _fetchPatientData,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      /// AVATAR + THÔNG TIN TÊN
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.blue.shade100,
                                  backgroundImage: _patientData?['HinhAnh'] != null
                                      ? NetworkImage(_patientData!['HinhAnh'].toString().startsWith('http')
                                          ? _patientData!['HinhAnh'].toString()
                                          : '${ApiConfig.domain}${_patientData!['HinhAnh']}')
                                      : null,
                                  child: _patientData?['HinhAnh'] == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 65,
                                          color: Color(0xff4b5fb5),
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: -5,
                                  right: -5,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Color(0xff4b5fb5),
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              _patientData?['HoTen'] ?? 'Chưa cập nhật',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1A237E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// THÔNG TIN CHI TIẾT
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            _infoItem(
                              Icons.badge_outlined,
                              "Mã bệnh nhân",
                              (_patientData?['MaBenhNhan'] ?? '').toString(),
                            ),
                            _infoItem(
                              Icons.cake_outlined,
                              "Ngày sinh",
                              _formatDate(_patientData?['NgaySinh']),
                            ),
                            _infoItem(
                              Icons.people_outline,
                              "Giới tính",
                              _patientData?['GioiTinh'] ?? 'Chưa cập nhật',
                            ),
                            _infoItem(
                              Icons.location_on_outlined,
                              "Địa chỉ",
                              _patientData?['DiaChi'] ?? 'Chưa cập nhật',
                            ),
                            _infoItem(
                              Icons.phone_outlined,
                              "Số điện thoại",
                              _patientData?['SDT'] ?? 'Chưa cập nhật',
                            ),
                            _infoItem(
                              Icons.email_outlined,
                              "Email",
                              _patientData?['Email'] ?? 'Chưa cập nhật',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// BẢO MẬT
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              size: 35,
                              color: Color(0xff4b5fb5),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bảo mật thông tin",
                                    style: TextStyle(
                                      color: Color(0xff4b5fb5),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Thông tin của bạn được bảo mật và chỉ dùng cho chăm sóc sức khỏe",
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      /// NÚT CẬP NHẬT THÔNG TIN
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4b5fb5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CapNhatThongTin(patientData: _patientData),
                              ),
                            );
                            if (result == true) {
                              _fetchPatientData();
                            }
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Cập nhật thông tin",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _infoItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}