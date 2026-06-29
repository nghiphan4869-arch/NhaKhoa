import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/TrangChu.dart';
import 'package:nhakhoa/services/auth_service.dart';

class XacNhanMatKhauMoi extends StatefulWidget {
  final String newPassword;
  final String? emailOrPhone; // Truyền vào nếu đi từ luồng quên mật khẩu

  const XacNhanMatKhauMoi({
    super.key,
    required this.newPassword,
    this.emailOrPhone,
  });

  @override
  State<XacNhanMatKhauMoi> createState() => _XacNhanMatKhauMoiState();
}

class _XacNhanMatKhauMoiState extends State<XacNhanMatKhauMoi> {
  final TextEditingController _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _verifyAndNavigate() async {
    final enteredPassword = _passwordController.text;

    if (enteredPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập mật khẩu mới để xác thực"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (enteredPassword != widget.newPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mật khẩu nhập vào không chính xác. Vui lòng kiểm tra lại!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Nếu mật khẩu khớp
    if (widget.emailOrPhone != null) {
      // Đi từ luồng quên mật khẩu -> Cần gọi API Đăng nhập để thiết lập phiên đăng nhập
      setState(() {
        _isLoading = true;
      });
      try {
        final user = await AuthService.login(widget.emailOrPhone!, enteredPassword);
        if (user != null) {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const TrangChu()),
              (route) => false,
            );
          }
        } else {
          throw Exception("Đăng nhập thất bại");
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Không thể thiết lập phiên đăng nhập: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      // Đi từ luồng đổi mật khẩu khi đã đăng nhập sẵn
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TrangChu()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Tiêu đề chính
                const Text(
                  "Xác nhận mật khẩu",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1b3f99),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Vui lòng nhập lại mật khẩu mới bạn vừa tạo để xác nhận truy cập vào ứng dụng.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),

                // Icon chìa khóa bảo mật
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffeef5ff),
                  ),
                  child: const Icon(
                    Icons.vpn_key_outlined,
                    color: Color(0xff4b5fb5),
                    size: 65,
                  ),
                ),
                const SizedBox(height: 40),

                // Ô nhập mật khẩu mới
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      labelText: "Mật khẩu mới của bạn",
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xff4b5fb5),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                        icon: Icon(
                          _hidePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Nút Xác nhận
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4b5fb5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _verifyAndNavigate,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Xác nhận",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
