import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'DangNhap.dart';

class DoiMatKhau extends StatefulWidget {
  const DoiMatKhau({super.key});

  @override
  State<DoiMatKhau> createState() => _DoiMatKhauState();
}

class _DoiMatKhauState extends State<DoiMatKhau> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideCurrentPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;
  bool _isLoading = false;
  int? _maTaiKhoan;

  @override
  void initState() {
    super.initState();
    _loadMaTaiKhoan();
  }

  Future<void> _loadMaTaiKhoan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _maTaiKhoan = prefs.getInt('maTaiKhoan');
      });
    } catch (e) {
      print('Lỗi tải mã tài khoản: $e');
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (_maTaiKhoan == null || _maTaiKhoan == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lỗi: Không tìm thấy phiên đăng nhập. Vui lòng đăng nhập lại."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentPw = _currentPasswordController.text;
    final newPw = _newPasswordController.text;

    if (currentPw == newPw) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mật khẩu mới không được trùng với mật khẩu cũ!"),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.changePassword(
        maTaiKhoan: _maTaiKhoan!,
        matKhauCu: currentPw,
        matKhauMoi: newPw,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        if (!mounted) return;
        
        // Show success alert and navigate back to login
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text(
                  "Thành công",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: const Text(
              "Đổi mật khẩu thành công! Vui lòng đăng nhập lại bằng mật khẩu mới.",
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1b3f99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(ctx);
                  
                  // Clear login session
                  await AuthService.logout();
                  
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const DangNhap()),
                      (route) => false,
                    );
                  }
                },
                child: const Text(
                  "Đồng ý",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? "Có lỗi xảy ra, vui lòng thử lại."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lỗi kết nối tới hệ thống. Vui lòng kiểm tra lại."),
          backgroundColor: Colors.red,
        ),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// Nút quay lại
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xff1b3f99),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Tiêu đề
                  const Text(
                    "Đổi mật khẩu",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1b3f99),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Thay đổi mật khẩu tài khoản của bạn định kỳ để bảo vệ thông tin cá nhân tốt hơn.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Form chứa các input
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xfffafcff),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Mật khẩu cũ
                        TextFormField(
                          controller: _currentPasswordController,
                          obscureText: _hideCurrentPassword,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Vui lòng nhập mật khẩu hiện tại";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Mật khẩu hiện tại",
                            hintText: "Nhập mật khẩu hiện tại",
                            prefixIcon: const Icon(Icons.lock_open),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _hideCurrentPassword = !_hideCurrentPassword;
                                });
                              },
                              icon: Icon(
                                _hideCurrentPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Mật khẩu mới
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: _hideNewPassword,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Vui lòng nhập mật khẩu mới";
                            }
                            if (value.length < 6) {
                              return "Mật khẩu phải tối thiểu từ 6 ký tự";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Mật khẩu mới",
                            hintText: "Nhập mật khẩu mới",
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _hideNewPassword = !_hideNewPassword;
                                });
                              },
                              icon: Icon(
                                _hideNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Xác nhận mật khẩu mới
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _hideConfirmPassword,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Vui lòng xác nhận mật khẩu mới";
                            }
                            if (value != _newPasswordController.text) {
                              return "Xác nhận mật khẩu không trùng khớp";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Xác nhận mật khẩu mới",
                            hintText: "Nhập lại mật khẩu mới",
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _hideConfirmPassword = !_hideConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _hideConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Nút Đổi mật khẩu
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1b3f99),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleChangePassword,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              "Cập nhật mật khẩu",
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
      ),
    );
  }
}
