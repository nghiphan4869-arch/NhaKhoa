import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/Dangnhap.dart';
import 'package:nhakhoa/services/auth_service.dart';

class DangKy extends StatefulWidget {
  const DangKy({super.key});

  @override
  State<DangKy> createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool agree = false;
  bool isLoading = false;

  final TextEditingController txtHoTen = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtSDT = TextEditingController();
  final TextEditingController txtMatKhau = TextEditingController();
  final TextEditingController txtConfirmMatKhau = TextEditingController();

  void _handleRegister() async {
    final String hoTen = txtHoTen.text.trim();
    final String email = txtEmail.text.trim();
    final String sdt = txtSDT.text.trim();
    final String matKhau = txtMatKhau.text;
    final String confirmMatKhau = txtConfirmMatKhau.text;

    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đồng ý với Điều khoản và Chính sách bảo mật'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (hoTen.isEmpty || email.isEmpty || sdt.isEmpty || matKhau.isEmpty || confirmMatKhau.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@gmail\.com$");
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email không đúng định dạng (phải là @gmail.com)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final RegExp phoneRegex = RegExp(r'^0[0-9]{9}$');
    if (!phoneRegex.hasMatch(sdt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Số điện thoại không hợp lệ (phải gồm 10 chữ số và bắt đầu bằng số 0)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (matKhau.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu phải tối thiểu 6 ký tự'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (matKhau.contains(' ')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu không được chứa khoảng trắng'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (matKhau != confirmMatKhau) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu xác nhận không khớp'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final success = await AuthService.register(
        hoTen: hoTen,
        email: email,
        sdt: sdt,
        matKhau: matKhau,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký tài khoản thành công!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DangNhap()),
          );
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text('Đăng ký thất bại'),
              content: const Text('Đăng ký thất bại. Email hoặc Số điện thoại có thể đã tồn tại.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text('Lỗi kết nối'),
            content: const Text('Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại sau.'),
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
          isLoading = false;
        });
      }
    }
  }

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
                          controller: txtHoTen,
                        ),

                        const SizedBox(height: 15),

                        _buildTextField(
                          label: "Email",
                          hint: "Nhập email (ví dụ: name@gmail.com)",
                          icon: Icons.email_outlined,
                          controller: txtEmail,
                        ),

                        const SizedBox(height: 15),

                        _buildTextField(
                          label: "Số điện thoại",
                          hint: "Nhập số điện thoại",
                          icon: Icons.phone_outlined,
                          controller: txtSDT,
                        ),

                        const SizedBox(height: 15),

                        _buildPasswordField(
                          label: "Mật khẩu",
                          hint: "Nhập mật khẩu",
                          hide: hidePassword,
                          controller: txtMatKhau,
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
                          controller: txtConfirmMatKhau,
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
                            onPressed: isLoading ? null : _handleRegister,
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
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
    required TextEditingController controller,
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
          controller: controller,
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
    required TextEditingController controller,
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
          controller: controller,
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