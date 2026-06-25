import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/CaNhan.dart';
import 'package:nhakhoa/Screen/CapNhatThongTin.dart';

class HoSoBenhNhan extends StatelessWidget {
  const HoSoBenhNhan({super.key});

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
            Navigator.push(context, MaterialPageRoute(builder: (context) => CaNhan(),),);
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// AVATAR + THÔNG TIN
            Center(
              child: Column(
                children: [

                  Stack(
                    clipBehavior: Clip.none,
                    children: [

                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.green.shade200,
                        child: const Icon(
                          Icons.person,
                          size: 65,
                          color: Colors.white,
                        ),
                      ),

                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
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
                            color: Colors.blue,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Phan C",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1A237E),
                    ),
                  ),     
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// THÔNG TIN
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
                    "8",
                  ),

                  _infoItem(
                    Icons.cake_outlined,
                    "Ngày sinh",
                    "Chưa cập nhật",
                  ),

                  _infoItem(
                    Icons.people_outline,
                    "Giới tính",
                    "Chưa cập nhật",
                  ),

                  _infoItem(
                    Icons.location_on_outlined,
                    "Địa chỉ",
                    "Chưa cập nhật",
                  ),

                  _infoItem(
                    Icons.phone_outlined,
                    "Số điện thoại",
                    "0902691111",
                  ),

                  _infoItem(
                    Icons.email_outlined,
                    "Email",
                    "c@gmail.com",
                  ),

                  _infoItem(
                    Icons.access_time,
                    "Ngày tạo hồ sơ",
                    "09/06/2025",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// GHI CHÚ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    "Ghi chú",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Chưa có ghi chú",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// BẢO MẬT
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: const Row(
                children: [

                  Icon(
                    Icons.shield_outlined,
                    size: 35,
                    color: Colors.blue,
                  ),

                  SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Bảo mật thông tin",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight:
                                FontWeight.bold,
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

            /// CẬP NHẬT THÔNG TIN
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1A73E8),
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CapNhatThongTin(),
                    ),
                  );
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