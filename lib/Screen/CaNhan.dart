import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/HoSoBenhNhan.dart';
import 'package:nhakhoa/Screen/NhacLichHen.dart';
import '../widgets/bottom_nav.dart';
import 'package:nhakhoa/Screen/Dangnhap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DoiMatKhau.dart';

class CaNhan extends StatelessWidget {
  const CaNhan({super.key});

  Future<Map<String, String>> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hoTen': prefs.getString('hoTen') ?? 'Khách',
      'sdt': prefs.getString('sdt') ?? 'Chưa cập nhật',
      'email': prefs.getString('email') ?? 'Chưa cập nhật',
      'maBenhNhan': (prefs.getInt('maBenhNhan') ?? 0).toString(),
      'ngaySinh': prefs.getString('ngaySinh') ?? 'Chưa cập nhật',
      'gioiTinh': prefs.getString('gioiTinh') ?? 'Chưa cập nhật',
      'diaChi': prefs.getString('diaChi') ?? 'Chưa cập nhật',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: FutureBuilder<Map<String, String>>(
          future: _getUserInfo(),
          builder: (context, snapshot) {
            final userInfo = snapshot.data ?? {};
            final hoTen = userInfo['hoTen'] ?? '...';
            final sdt = userInfo['sdt'] ?? '...';
            final email = userInfo['email'] ?? '...';
            final maBenhNhan = userInfo['maBenhNhan'] ?? '...';
            final ngaySinhRaw = userInfo['ngaySinh'] ?? '...';
            final gioiTinh = userInfo['gioiTinh'] ?? '...';
            final diaChi = userInfo['diaChi'] ?? '...';

            // Format ngày sinh từ yyyy-MM-dd thành dd/MM/yyyy
            String ngaySinh = ngaySinhRaw;
            if (ngaySinhRaw.contains('-')) {
              try {
                final parts = ngaySinhRaw.split('T')[0].split('-');
                if (parts.length == 3) {
                  ngaySinh = '${parts[2]}/${parts[1]}/${parts[0]}';
                }
              } catch (_) {}
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Cá nhân",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NhacLich(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications_none,
                          ),
                        )
                      ],
                    ),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Quản lý thông tin và tài khoản của bạn",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// THÔNG TIN USER
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xffeef5ff),
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 35,
                            backgroundColor:
                                Color(0xffd6df73),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hoTen,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(sdt),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(email),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Image.asset(
                            "assets/logo.png",
                            width: 70,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// HỒ SƠ BỆNH NHÂN
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Hồ sơ bệnh nhân",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HoSoBenhNhan(),
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "Xem chi tiết",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            "Mã bệnh nhân",
                            maBenhNhan == '0' ? 'Chưa có' : maBenhNhan,
                          ),
                          _buildInfoRow(
                            "Ngày sinh",
                            ngaySinh,
                          ),
                          _buildInfoRow(
                            "Giới tính",
                            gioiTinh,
                          ),
                          _buildInfoRow(
                            "Địa chỉ",
                            diaChi,
                          ),
                          _buildInfoRow(
                            "Ghi chú",
                            "chưa có",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// TÀI KHOẢN
                    _buildSectionTitle(
                      Icons.lock_outline,
                      Colors.red,
                      "Tài khoản và bảo mật",
                    ),

                    _buildMenuItem(
                      "Đổi mật khẩu",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DoiMatKhau(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// ỨNG DỤNG
                    _buildSectionTitle(
                      Icons.grid_view,
                      Colors.purple,
                      "Ứng dụng",
                    ),

                    _buildMenuItem(
                      "Nhắc lịch hẹn",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NhacLich(),
                          ),
                        );
                      },
                    ),

                    _buildMenuItem(
                      "Chat với bác sĩ",
                      () {},
                    ),

                    _buildMenuItem(
                      "Giới thiệu ứng dụng",
                      () {},
                    ),

                    const SizedBox(height: 30),

                    /// ĐĂNG XUẤT
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4b5fb5),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    15),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: const Text(
                                  "Đăng xuất",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text(
                                  "Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Hủy"),
                                  ),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff4b5fb5),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);

                                      // Gọi hàm logout
                                      final prefs = await SharedPreferences.getInstance();
                                      await prefs.clear();

                                      // Chuyển về màn hình đăng nhập
                                      if (context.mounted) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const DangNhap(),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      "Đăng xuất",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Đăng xuất",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNav(
        currentIndex: 4,
      ),
    );
  }

  Widget _buildSectionTitle(
    IconData icon,
    Color color,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      onTap: onTap,
    );
  }
}