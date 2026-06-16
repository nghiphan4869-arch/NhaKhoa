import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/NhacLichHen.dart';
import '../widgets/bottom_nav.dart';
import 'package:nhakhoa/Screen/Dangnhap.dart';

class CaNhan extends StatelessWidget {
  const CaNhan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: SingleChildScrollView(
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NhacLich(),),);
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
                          children: const [
                            Text(
                              "Bùi Thị Ngọc Như",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 16,
                                ),
                                SizedBox(width: 5),
                                Text("0123456789"),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 16,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "abc@gmail.com",
                                ),
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
                _buildSectionTitle(
                  Icons.person_outline,
                  Colors.blue,
                  "Hồ sơ bệnh nhân",
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
                        "SC-2000-122",
                      ),
                      _buildInfoRow(
                        "Ngày sinh",
                        "08/05/2005",
                      ),
                      _buildInfoRow(
                        "Giới tính",
                        "Nữ",
                      ),
                      _buildInfoRow(
                        "Nhóm máu",
                        "O",
                      ),
                      _buildInfoRow(
                        "Địa chỉ",
                        "TP.HCM",
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
                  () {},
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NhacLich(),),);
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
                      backgroundColor:Colors.red,
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
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);

                                  // Chuyển về màn hình đăng nhập
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DangNhap(),
                                    ),
                                    (route) => false,
                                  );
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