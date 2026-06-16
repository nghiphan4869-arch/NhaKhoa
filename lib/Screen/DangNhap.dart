import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/DangKy.dart';
import 'package:nhakhoa/Screen/QuenMatKhau.dart';
import 'package:nhakhoa/Screen/TrangChu.dart';

class DangNhap extends StatefulWidget {
  const DangNhap({super.key});

  @override
  State<DangNhap> createState() => _DangNhapState();
}

class _DangNhapState extends State<DangNhap> {
  
  final TextEditingController txtTaiKhoan =
    TextEditingController();

  final TextEditingController txtMatKhau =
    TextEditingController();

  bool isLoading = false;
  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffedf5ff),
                  Color(0xff9bc4ff),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Column(
                children: [
                  /// LOGO
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/logo.png",
                      width: 150,
                      height: 150,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// TIÊU ĐỀ + ẢNH RĂNG
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Chào mừng bạn\nđến với DentalCare",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1b3f99),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Đăng nhập để quản lý lịch hẹn,\ntheo dõi điều trị và nhận ưu đãi",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// FORM ĐĂNG NHẬP
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email/ Số điện thoại",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: txtTaiKhoan,
                          decoration: InputDecoration(
                            hintText:
                                "Nhập email/ số điện thoại",
                            prefixIcon: const Icon(
                              Icons.person_outline,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ), 
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Mật khẩu",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: txtMatKhau,
                          obscureText:
                              isPasswordHidden,
                          decoration: InputDecoration(
                            hintText:
                                "Nhập mật khẩu",
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordHidden =
                                      !isPasswordHidden;
                                });
                              },
                              icon: Icon(
                                isPasswordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment:
                              Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const QuenMatKhau(),),);
                            },
                            child: const Text(
                              "Quên mật khẩu?",
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                      0xff4b5fb5),
                              elevation: 0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TrangChu(),),);
                            },
                            child: const Text(
                              "Đăng nhập",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: const [
                            Expanded(
                              child: Divider(),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(
                                      horizontal: 10),
                              child: Text("Hoặc"),
                            ),
                            Expanded(
                              child: Divider(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding:
                              const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xffeef2ff),
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      "Bạn chưa có tài khoản ?",
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "Đăng ký ngay để đặt lịch và nhận ưu đãi!",
                                      style: TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const DangKy(),),);
                                },
                                child: const Text(
                                  "Đăng ký >",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}