import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/Dangnhap.dart';

class DangKy extends StatefulWidget {
  const DangKy({super.key});

  @override
  State<DangKy> createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  /// Logo
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/logo.png",
                      width: 150,
                      height: 150,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Tiêu đề
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Tạo tài khoản",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1b3f99),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Đăng ký để trải nghiệm dịch vụ\nchăm sóc răng miệng toàn diện",
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

                  const SizedBox(height: 20),

                  /// Form
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        _buildTextField(
                          label: "Họ và tên",
                          hint: "Nhập họ và tên",
                          icon: Icons.person_outline,
                        ),

                        const SizedBox(height: 15),

                        _buildTextField(
                          label: "Email",
                          hint: "Nhập email",
                          icon: Icons.email_outlined,
                        ),

                        const SizedBox(height: 15),

                        _buildTextField(
                          label: "Số điện thoại",
                          hint: "Nhập số điện thoại",
                          icon: Icons.phone_outlined,
                        ),

                        const SizedBox(height: 15),

                        _buildPasswordField(
                          label: "Mật khẩu",
                          hint: "Nhập mật khẩu",
                          hide: hidePassword,
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        _buildPasswordField(
                          label: "Xác nhận mật khẩu",
                          hint: "Nhập lại mật khẩu",
                          hide: hideConfirmPassword,
                          onPressed: () {
                            setState(() {
                              hideConfirmPassword =
                                  !hideConfirmPassword;
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: agree,
                              onChanged: (value) {
                                setState(() {
                                  agree = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          "Tôi đồng ý với ",
                                    ),
                                    TextSpan(
                                      text:
                                          "Điều khoản sử dụng",
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " và ",
                                    ),
                                    TextSpan(
                                      text:
                                          "Chính sách bảo mật",
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          " của DentalCare",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                      0xff4b5fb5),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        12),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Đăng ký",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Đã có tài khoản? ",
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DangNhap(),),);
                              },
                              child: const Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required bool hide,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: hide,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon:
                const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              onPressed: onPressed,
              icon: Icon(
                hide
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
      ],
    );
  }
}